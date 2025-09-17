module @minimarket::minimarket {
    use std::signer;
    use std::vector;

    /// Ошибки
    const E_ALREADY_INITIALIZED: u64 = 1;
    const E_NOT_INITIALIZED: u64 = 2;
    const E_BAD_FEE_BPS: u64 = 3;
    const E_ONLY_ADMIN: u64 = 4;
    const E_BAD_ITEM_ID: u64 = 5;
    const E_ALREADY_LISTED: u64 = 6;
    const E_NOT_LISTED: u64 = 7;
    const E_PRICE_MISMATCH: u64 = 8;

    /// Простая запись о лоте
    struct Item has drop, store {
        seller: address,
        price: u64,
        listed: bool,
    }

    /// Баланс внутри модуля (псевдо-коины для демо)
    struct Balance has drop, store {
        owner: address,
        amount: u64,
    }

    /// Синглтон маркетплейса, хранится под адресом администратора (инициатора init).
    struct Market has key {
        admin: address,
        fee_bps: u64,              // 0..=10_000
        fees_accumulated: u64,     // Накопленные комиссии
        items: vector<Item>,       // По индексу = item_id
        balances: vector<Balance>, // Простая "карта": поиск по адресу линейный
        initialized: bool,
    }

    /// === helpers ===

    fun assert_initialized(market_addr: address) {
        assert!(exists<Market>(market_addr), E_NOT_INITIALIZED);
    }

    fun only_admin(market: &Market, caller: address) {
        assert!(market.admin == caller, E_ONLY_ADMIN);
    }

    fun get_mut(market_addr: address): &mut Market acquires Market {
        let m = borrow_global_mut<Market>(market_addr);
        m
    }

    fun get(market_addr: address): &Market acquires Market {
        let m = borrow_global<Market>(market_addr);
        m
    }

    /// Найти индекс баланса по адресу, либо вернуть опционально None.
    fun find_balance_index(balances: &vector<Balance>, owner: address): (bool, u64) {
        let i = 0u64;
        let len = vector::length(balances);
        while (i < len) {
            let b = vector::borrow(balances, i);
            if (b.owner == owner) {
                return (true, i)
            };
            i = i + 1;
        };
        (false, 0)
    }

    /// Кредитовать внутренний баланс.
    fun credit_balance(balances: &mut vector<Balance>, owner: address, amount: u64) {
        let (found, idx) = find_balance_index(balances, owner);
        if (found) {
            let b = vector::borrow_mut(balances, idx);
            b.amount = b.amount + amount;
        } else {
            vector::push_back(balances, Balance { owner, amount });
        }
    }

    /// === entry ===

    /// Инициализация маркетплейса под адресом администратора (signer).
    public entry fun init(admin: &signer, fee_bps: u64) acquires Market {
        let admin_addr = signer::address_of(admin);
        assert!(!exists<Market>(admin_addr), E_ALREADY_INITIALIZED);
        assert!(fee_bps <= 10000, E_BAD_FEE_BPS);

        move_to(admin, Market {
            admin: admin_addr,
            fee_bps,
            fees_accumulated: 0,
            items: vector::empty<Item>(),
            balances: vector::empty<Balance>(),
            initialized: true
        });
    }

    /// Размещение лота. Если item_id == len, пушим новый; если меньше len — ячейка должна быть свободна.
    public entry fun list(seller: &signer, market_addr: address, item_id: u64, price: u64) acquires Market {
        assert_initialized(market_addr);
        let seller_addr = signer::address_of(seller);
        let m = get_mut(market_addr);

        let len = vector::length(&m.items);
        if (item_id == len) {
            vector::push_back(&mut m.items, Item { seller: seller_addr, price, listed: true });
        } else {
            assert!(item_id < len, E_BAD_ITEM_ID);
            let it = vector::borrow_mut(&mut m.items, item_id);
            // Разрешаем перезалистинг только если ячейка свободна
            assert!(!it.listed, E_ALREADY_LISTED);
            it.seller = seller_addr;
            it.price = price;
            it.listed = true;
        }
    }

    /// Покупка лота. Внутренняя «оплата»: увеличиваем баланс продавца, удерживаем комиссию в пуле.
    public entry fun buy(buyer: &signer, market_addr: address, item_id: u64, pay_amount: u64) acquires Market {
        assert_initialized(market_addr);
        let m = get_mut(market_addr);
        let len = vector::length(&m.items);
        assert!(item_id < len, E_BAD_ITEM_ID);

        let it = vector::borrow_mut(&mut m.items, item_id);
        assert!(it.listed, E_NOT_LISTED);
        assert!(pay_amount == it.price, E_PRICE_MISMATCH);

        // комиссия: (price * fee_bps) / 10000
        let fee = (it.price * m.fee_bps) / 10000;
        let seller_amount = it.price - fee;

        // начисляем продавцу, накапливаем комиссию
        credit_balance(&mut m.balances, it.seller, seller_amount);
        m.fees_accumulated = m.fees_accumulated + fee;

        // снимаем лот
        it.listed = false;
    }

    /// Вывод комиссий админом во внутренний баланс админа
    public entry fun withdraw_fees(admin: &signer, market_addr: address) acquires Market {
        assert_initialized(market_addr);
        let caller = signer::address_of(admin);
        let m = get_mut(market_addr);
        only_admin(m, caller);

        let amount = m.fees_accumulated;
        if (amount > 0) {
            m.fees_accumulated = 0;
            credit_balance(&mut m.balances, caller, amount);
        }
    }

    /// Просмотр баланса (для тестов/демо)
    public fun view_balance(market_addr: address, owner: address): u64 acquires Market {
        let m = get(market_addr);
        let (found, idx) = find_balance_index(&m.balances, owner);
        if (!found) { 0 } else { vector::borrow(&m.balances, idx).amount }
    }

    /// Демонстрационная процедура (сценарий happy-path)
    public entry fun entry_demo(admin: &signer) acquires Market {
        // 1) init с 250 bps = 2.5%
        init(admin, 250);
        let admin_addr = signer::address_of(admin);

        // 2) Продавец = админ для простоты. Листинг item_id=0 по цене 10_000
        list(admin, admin_addr, 0, 10_000);

        // 3) Покупка тем же аккаунтом для демо (в реале будет другой signer)
        buy(admin, admin_addr, 0, 10_000);

        // 4) Вывод комиссии админом
        withdraw_fees(admin, admin_addr);
        // Теперь у админа во внутреннем балансе 10_000 (от продажи) + 250 (комиссия) не будет,
        // комиссия не прибавляется к продавцу; продавцу ушло 9_750, комиссия 250 ушла в пул и затем на баланс админа.
        // Проверки оставляем в юнит-тестах.
    }
}
