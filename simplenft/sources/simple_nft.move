module SimpleNFT::nft {
-    use std::signer;
-    use std::vector;
-    use std::string;
+    use 0x1::signer;
+    use 0x1::vector;
+    use 0x1::string;


    /// Примитивный NFT (без рыночной логики)
    struct NFT has key {
        id: u64,
        name: string::String,
        owner: address,
    }

    struct Registry has key {
        next_id: u64,
        items: vector<NFT>,
    }

    public fun new_registry(_admin: &signer): Registry {
        Registry { next_id: 0, items: vector::empty<NFT>() }
    }

    public fun mint(admin: &signer, r: &mut Registry, to: address, name: string::String) {
        let id = r.next_id;
        r.next_id = id + 1;
        let nft = NFT { id, name, owner: to };
        vector::push_back(&mut r.items, nft);
    }

    public fun transfer(_caller: &signer, r: &mut Registry, id: u64, to: address) {
        let len = vector::length(&r.items);
        let i = find_index(&r.items, id);
        let mut nft = vector::borrow_mut(&mut r.items, i);
        nft.owner = to;
    }

    public fun get_owner(r: &Registry, id: u64): address {
        let i = find_index(&r.items, id);
        let nft = vector::borrow(&r.items, i);
        nft.owner
    }

    fun find_index(items: &vector<NFT>, id: u64): u64 {
        let i = 0;
        while (i < vector::length(items)) {
            let nft_ref = vector::borrow(items, i);
            if (nft_ref.id == id) return i;
            i = i + 1;
        };
        // если не нашли — для учебного проекта просто вернём 0
        0
    }
}
