module SimpleNFT::nft {
    /// Minimal NFT without strings/vectors/signers
    struct NFT has store {
        id: u64,
        owner: address,
    }

    /// Mint an NFT to owner with id
    public fun mint(id: u64, owner: address): NFT {
        NFT { id, owner }
    }

    /// Transfer ownership
    public fun transfer(n: &mut NFT, to: address) {
        n.owner = to;
    }

    /// Read owner
    public fun owner_of(n: &NFT): address {
        n.owner
    }
}
