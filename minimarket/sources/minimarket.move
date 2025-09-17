module minimarket::minimarket {
    use std::signer;
    use std::vector;

    const E_ALREADY_INITIALIZED: u64 = 1;
    const E_NOT_INITIALIZED: u64 = 2;
    const E_BAD_FEE_BPS: u64 = 3;
    const E_ONLY_ADMIN: u64 = 4;
    const E_BAD_ITEM_ID: u64 = 5;
    const E_ALREADY_LISTED: u64 = 6;
    const E_NOT_LISTED: u64 = 7;
    const E_PRICE_MISMATCH: u64 = 8;

    struct Item has drop, store {
        seller: address,
        price: u64,
        listed: bool,
    }

    struct Balance has drop, store {
        owner: address,
        amount: u64,
    }

    struct Market has key {
        admin: address,
        fee_bps: u64,
        fees_accumulated: u64,
        items: vector<Item>,
        balances: vector<Balance>,
        initialized: bool,
    }

    fun assert_initialized(market_addr: address) {
        assert!(exists<Market>(market_addr), E_NOT_INITIALIZED);
    }

    fun only_admin(market: &Market, caller: address) {
        assert!(market.admin == caller, E_ONLY_ADMIN);
    }

    fun get_mut(market_addr: address): &mut Market acquires Market {
        borrow_global_mut<Market>(market_addr)
    }

    fun get(market_addr: address): &Market acquires Market {
        borrow_global<Market>(market_addr)
    }

    fun find_balance_index(balances: &vector<Balance>, owner: address): (bool, u64) {
        let i = 0u64;
        let len = vector::length(balances);
        while (i < len) {
            let b = vector::borrow(balances, i);
            if (b.owner == owner) return (true, i);
            i = i + 1;
        };
        (false, 0)
    }

    fun credit_balance(balances: &mut vector<Balance>, owner: address, amount: u64) {
        let (found, idx) = find_balance_index(balances, owner);
        if (found) {
            let b = vector::borrow_mut(balances, idx);
            b.amount = b.amount + amount;
        } else {
            vector::push_back(balances, Balance { owner, amount });
        }
    }

    /// init(admin, fee_bps: 0..=10000)
    /// ВАЖНО: здесь НЕТ `acquires`, мы не читаем/не извлекаем глобальные ресурсы; только `exists` + `move_to`.
    public entry fun init(admin: &signer, fee_bps: u64) {
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

    /// list(item_id, price). Если item_id == len(items) — добавляем новый слот.
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
            assert!(!it.listed, E_ALREADY_LISTED);
            it.seller = seller_addr;
            it.price = price;
            it.listed = true;
        }
    }

    /// buy(item_id, pay_amount == price). Комиссия удерживается в пуле.
    public entry fun buy(buyer: &signer, market_addr: address, item_id: u64, pay_amount: u64) acquires Market {
        assert_initialized(market_addr);
        let m = get_mut(market_addr);
        let len = vector::length(&m.items);
        assert!(item_id < len, E_BAD_ITEM_ID);

        let it = vector::borrow_mut(&mut m.items, item_id);
        assert!(it.listed, E_NOT_LISTED);
        assert!(pay_amount == it.price, E_PRICE_MISMATCH);

        let fee = (it.price * m.fee_bps) / 10000;
        let seller_amount = it.price - fee;

        credit_balance(&mut m.balances, it.seller, seller_amount);
        m.fees_accumulated = m.fees_accumulated + fee;

        it.listed = false;
    }

    /// withdraw_fees(): админ зачисляет накопленную комиссию на свой внутренний баланс.
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

    /// Просмотр внутреннего баланса (для демо/тестов)
    public fun view_balance(market_addr: address, owner: address): u64 acquires Market {
        let m = get(market_addr);
        let (found, idx) = find_balance_index(&m.balances, owner);
        if (!found) { 0 } else { vector::borrow(&m.balances, idx).amount }
    }

    /// Быстрый сценарий: init(2.5%), list(0,10_000), buy, withdraw_fees.
    public entry fun entry_demo(admin: &signer) acquires Market {
        init(admin, 250);
        let admin_addr = signer::address_of(admin);
        list(admin, admin_addr, 0, 10_000);
        buy(admin, admin_addr, 0, 10_000);
        withdraw_fees(admin, admin_addr);
    }
}
