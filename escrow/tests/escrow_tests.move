#[test_only]
module 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::escrow_tests {
    use 0x1::signer;
    use 0x1::vector;
    use 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::escrow;

    const BUYER: address = @0x1;
    const SELLER: address = @0x2;

    // Мусорка, чтобы не было implicit drop для Wallet/Deal
    struct Trash has key {
        buyers: vector<escrow::Wallet>,
        sellers: vector<escrow::Wallet>,
        deals: vector<escrow::Deal>,
    }

    public entry fun init_trash(s: &signer) {
        move_to(s, Trash {
            buyers: vector::empty<escrow::Wallet>(),
            sellers: vector::empty<escrow::Wallet>(),
            deals: vector::empty<escrow::Deal>(),
        });
    }

    fun sink_all(s: &signer, bw: escrow::Wallet, sw: escrow::Wallet, d: escrow::Deal) acquires Trash {
        let t = borrow_global_mut<Trash>(signer::address_of(s));
        vector::push_back(&mut t.buyers, bw);
        vector::push_back(&mut t.sellers, sw);
        vector::push_back(&mut t.deals, d);
    }

    // === happy path: deposit -> fund -> release ===
    #[test(admin = @0xAA)]
    public entry fun test_happy(admin: &signer) acquires Trash {
        init_trash(admin);

        let bw = escrow::new_wallet();
        let sw = escrow::new_wallet();

        escrow::deposit(&mut bw, 150);
        let d = escrow::create(BUYER, SELLER, 100);

        escrow::fund(BUYER, &mut bw, &mut d);
        escrow::release(SELLER, &mut sw, &mut d);

        assert!(escrow::balance(&bw) == 50, 0);
        assert!(escrow::balance(&sw) == 100, 1);

        sink_all(admin, bw, sw, d);
    }

    // Нельзя фондить недостаточную сумму (E_INSUFFICIENT = 4)
    #[test(admin = @0xAB)]
    #[expected_failure(abort_code = 4, location = 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::escrow)]
    public entry fun test_insufficient(admin: &signer) acquires Trash {
        init_trash(admin);

        let bw = escrow::new_wallet();
        let sw = escrow::new_wallet();

        escrow::deposit(&mut bw, 50); // меньше, чем нужно
        let d = escrow::create(BUYER, SELLER, 100);

        // упадёт по E_INSUFFICIENT (4)
        escrow::fund(BUYER, &mut bw, &mut d);

        sink_all(admin, bw, sw, d);
    }

    // Нельзя фондить не-байеру (E_NOT_BUYER = 5)
    #[test(admin = @0xAC)]
    #[expected_failure(abort_code = 5, location = 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::escrow)]
    public entry fun test_not_buyer(admin: &signer) acquires Trash {
        init_trash(admin);

        let bw = escrow::new_wallet();
        let sw = escrow::new_wallet();

        escrow::deposit(&mut bw, 150);
        let d = escrow::create(BUYER, SELLER, 100);

        // адрес не совпадает с BUYER
        escrow::fund(@0xDEAD, &mut bw, &mut d);

        sink_all(admin, bw, sw, d);
    }
}
