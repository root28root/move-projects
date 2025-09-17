#[test_only]
module 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::my_token_tests {
    use 0x1::signer;
    use 0x1::option;
    use 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::coin;

    /// Тестовая «мусорка», чтобы не дропать Coin локально.
    struct Trash has key { inner: option::Option<coin::Coin> }

    public entry fun init_trash(s: &signer) {
        move_to(s, Trash { inner: option::none<coin::Coin>() });
    }

    fun sink(s: &signer, c: coin::Coin) acquires Trash {
        let t = borrow_global_mut<Trash>(signer::address_of(s));
        // Если уже что-то лежит — перезапишем, тестам это ок.
        t.inner = option::some<coin::Coin>(c);
    }

    // === Позитивы ===

    #[test(admin = @0xA)]
    public entry fun test_mint_balance_ok(admin: &signer) acquires Trash {
        init_trash(admin);
        let c = coin::mint(100);
        assert!(coin::balance(&c) == 100, 0);
        sink(admin, c); // поглотили, локальных Coin без drop не осталось
    }

    #[test(admin = @0xB)]
    public entry fun test_transfer_split_ok(admin: &signer) acquires Trash {
        init_trash(admin);
        let c = coin::mint(100);
        let (c1, c2) = coin::split(c, 60); // 60 и 40
        assert!(coin::balance(&c1) == 60, 1);
        assert!(coin::balance(&c2) == 40, 2);
        sink(admin, c1);
        sink(admin, c2);
    }

    // === Негатив ===

    #[test(admin = @0xC)]
    #[expected_failure] // ожидаем падение при сплите > баланса
    public entry fun test_split_fail_overflow(admin: &signer) acquires Trash {
        init_trash(admin);
        let c = coin::mint(10);
        let (_a, _b) = coin::split(c, 11);
        // Если почему-то не упало — всё равно поглотим, чтобы не дропнулось
        sink(admin, _a);
        sink(admin, _b);
    }
}
