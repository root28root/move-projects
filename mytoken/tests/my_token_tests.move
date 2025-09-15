module MyToken::coin_tests {
    use MyToken::coin;

    #[test]
    public fun test_mint_and_balance() {
        let c = coin::mint(100);
        assert!(coin::balance(&c) == 100, 0);
    }

    #[test]
    public fun test_transfer() {
        let c1 = coin::mint(100);
        let c2 = coin::transfer(&mut c1, 40);
        assert!(coin::balance(&c1) == 60, 1);
        assert!(coin::balance(&c2) == 40, 2);
    }

    #[test]
    public fun test_burn() {
        let c = coin::mint(50);
        let burned = coin::burn(c);
        assert!(burned == 50, 3);
    }
}

