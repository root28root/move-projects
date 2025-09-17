#[test_only]
module MyToken::my_token_tests {
    use 0x1::vector;
    use MyToken::coin;

    // Простой «синк», чтобы не дропать ресурс coin::Coin
    struct Trash has key { inner: vector<coin::Coin> }

    public entry fun init_trash(acc: &signer) {
        move_to(acc, Trash { inner: vector::empty<coin::Coin>() });
    }

    fun sink(acc: &signer, c: coin::Coin) acquires Trash {
        let t = borrow_global_mut<Trash>(signer::address_of(acc));
        vector::push_back(&mut t.inner, c);
    }

    #[test(admin = @0xA)]
    public entry fun test_mint_balance_ok(admin: &signer) acquires Trash {
        init_trash(admin);
        let c = coin::mint(100);
        assert!(coin::balance(&c) == 100, 0);
        sink(admin, c);
    }

    // Негатив: попытка «borrow_global» там, где ресурса нет — падать не должно,
    // если модуль coin не хранит глобальное состояние. Этот тест чисто как шаблон:
    // можно удалить, если у coin нет такого поведения.
}
