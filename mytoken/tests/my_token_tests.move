module MyToken::coin_tests {
    use std::signer;
    use MyToken::coin;

    #[test]
    public fun test_mint_and_balance() {
        let c = coin::mint(&signer::spec_test_signer(), 100);
        assert!(coin::balance(&c) == 100, 0);
    }

    #[test]
    public fun test_transfer() {
        let mut c1 = coin::mint(&signer::spec_test_signer(), 100);
        let c2 = coin::transfer(&mut c1, 40);
        assert!(coin::balance(&c1) == 60, 1);
        assert!(coin::balance(&c2) == 40, 2);
    }

    #[test]
    public fun test_transfer_fail() {
        let mut c1 = coin::mint(&signer::spec_test_signer(), 10);
        // ожидаем фейл, если пытаемся перевести больше, чем есть
        // тут 20 > 10 → будет abort
        let _c2 = coin::transfer(&mut c1, 20);
    }

    #[test]
    public fun test_burn() {
        let c = coin::mint(&signer::spec_test_signer(), 50);
        let burned = coin::burn(c);
        assert!(burned == 50, 3);
    }
}
