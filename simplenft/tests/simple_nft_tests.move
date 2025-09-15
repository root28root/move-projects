module SimpleNFT::nft_tests {
    use SimpleNFT::nft;

    const A1: address = @0x1;
    const A2: address = @0x2;

    #[test]
    public fun mint_and_transfer() {
        let n = nft::mint(0, A1);
        assert!(nft::owner_of(&n) == A1, 0);
        nft::transfer(&mut n, A2);
        assert!(nft::owner_of(&n) == A2, 1);
    }
}
