#[test_only]
module 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::my_token_tests {
    use 0x1::signer;
    use 0x1::vector;
    use 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::coin;

    /// «Мусорка», чтобы не дропать Coin локально: складируем в вектор.
    struct Trash has key { inner: vector<coin::Coin> }

    public entry fun init_trash(s: &signer) {
        move_to(s, Trash { inner: vector::empty<coin::Coin>() });
    }

    fun sink(s: &signer, c: coin::Coin) acquires Trash {
        let t = borrow_global_mut<Trash>(signer::address_of(s));
        vector::push_back(&mut t.inner, c);
    }

    // === Позитивы ===

    #[test(admin = @0xA)]
    public entry fun test_mint_balance_ok(admin: &signer) acquires Trash {
        init_trash(admin);
        let c = coin::mint(100);
        assert!(coin::balance(&c) == 100, 0);
        sink(admin, c);
    }

    #[test(admin = @0xB)]
    public entry fun test_two_mints_sum_ok(admin: &signer) acquires Trash {
        init_trash(admin);
        let c1 = coin::mint(60);
        let c2 = coin::mint(40);
        let total = coin::balance(&c1) + coin::balance(&c2);
        assert!(total == 100, 1);
        sink(admin, c1);
        sink(admin, c2);
    }

    // === Негатив ===
    // Без init_trash ресурса ещё нет — borrow_global_mut абортит.
    #[test(user = @0xC)]
    #[expected_failure]
    public entry fun test_borrow_without_init_fails(user: &signer) acquires Trash {
        let _t = borrow_global_mut<Trash>(signer::address_of(user));
    }
}
