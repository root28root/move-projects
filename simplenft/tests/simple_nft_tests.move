module SimpleNFT::nft_tests {
    use std::signer;
    use std::string;
    use SimpleNFT::nft;

    #[test]
    public fun mint_and_transfer() {
        let admin = signer::spec_test_signer();
        let user1 = signer::spec_test_signer();
        let user2 = signer::spec_test_signer();

        let mut reg = nft::new_registry(&admin);

        nft::mint(&admin, &mut reg, signer::address_of(&user1), string::utf8(b"Genesis"));
        assert!(nft::get_owner(&reg, 0) == signer::address_of(&user1), 0);

        nft::transfer(&user1, &mut reg, 0, signer::address_of(&user2));
        assert!(nft::get_owner(&reg, 0) == signer::address_of(&user2), 1);
    }
}
