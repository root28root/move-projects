#[test_only]
module 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::simple_nft_tests {
    use 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::nft;

    const A1: address = @0x1;
    const A2: address = @0x2;

    #[test]
    public entry fun test_mint_transfer_ok() {
        let r = nft::new_registry();

        nft::mint(&mut r, A1, b"Test NFT");
        assert!(nft::get_owner(&r, 0) == A1, 0);

        nft::transfer(&mut r, 0, A2);
        assert!(nft::get_owner(&r, 0) == A2, 1);

        nft::destroy_for_test(r);
    }

    // Повторный mint должен падать с кодом 1 из SimpleNFT::nft::mint
    #[test]
    #[expected_failure(abort_code = 1, location = SimpleNFT::nft)]
    public entry fun test_mint_twice_fails() {
        let r = nft::new_registry();
        nft::mint(&mut r, A1, b"x");
        // второй mint -> abort(1)
        nft::mint(&mut r, A1, b"y");
        // не дойдём, но чтобы удовлетворить типы:
        nft::destroy_for_test(r);
    }

    // Неверный id при transfer -> abort(3) в SimpleNFT::nft::transfer
    #[test]
    #[expected_failure(abort_code = 3, location = SimpleNFT::nft)]
    public entry fun test_transfer_wrong_id_fails() {
        let r = nft::new_registry();
        nft::mint(&mut r, A1, b"x");
        nft::transfer(&mut r, /*wrong*/ 999, A2);
        nft::destroy_for_test(r);
    }

    // Неверный id при get_owner -> abort(5) в SimpleNFT::nft::get_owner
    #[test]
    #[expected_failure(abort_code = 5, location = SimpleNFT::nft)]
    public entry fun test_get_owner_wrong_id_fails() {
        let r = nft::new_registry();
        nft::mint(&mut r, A1, b"x");
        let _ = nft::get_owner(&r, /*wrong*/ 123);
        nft::destroy_for_test(r);
    }
}
