#[test_only]
module PaySplit::split_tests {
    use 0x1::signer;
    use 0x1::vector;
    use PaySplit::split;

    const A1: address = @0x1;
    const A2: address = @0x2;
    const A3: address = @0x3;

    // Happy path: 100 with shares [3,1] → 75/25
    #[test(admin = @0xA, payer = @0xB)]
    public entry fun test_split_3_1(admin: &signer, payer: &signer) {
        // recipients = [A1, A2]
        let recips = vector::singleton<address>(A1);
        let tail_r = vector::singleton<address>(A2);
        vector::append(&mut recips, tail_r);

        // shares = [3, 1]
        let shares = vector::singleton<u64>(3);
        let tail_s = vector::singleton<u64>(1);
        vector::append(&mut shares, tail_s);

        split::init(admin, recips, shares);
        let admin_addr = signer::address_of(admin);

        split::deposit(payer, admin_addr, 100);

        assert!(split::view_balance(admin_addr, A1) == 75, 0);
        assert!(split::view_balance(admin_addr, A2) == 25, 1);
    }

    // Remainder path: [1,1,1] & 100 → each 33, remainder 1 → admin can withdraw fees
    #[test(admin = @0xC, payer = @0xD, a1 = @0x1, a2 = @0x2, a3 = @0x3)]
    public entry fun test_remainder_and_withdraw(admin: &signer, payer: &signer, a1: &signer, a2: &signer, a3: &signer) {
        let addrs = vector::empty<address>();
        vector::push_back(&mut addrs, signer::address_of(a1));
        vector::push_back(&mut addrs, signer::address_of(a2));
        vector::push_back(&mut addrs, signer::address_of(a3));

        let shares = vector::empty<u64>();
        vector::push_back(&mut shares, 1);
        vector::push_back(&mut shares, 1);
        vector::push_back(&mut shares, 1);

        split::init(admin, addrs, shares);
        let admin_addr = signer::address_of(admin);

        split::deposit(payer, admin_addr, 100);

        assert!(split::view_balance(admin_addr, signer::address_of(a1)) == 33, 0);
        assert!(split::view_balance(admin_addr, signer::address_of(a2)) == 33, 1);
        assert!(split::view_balance(admin_addr, signer::address_of(a3)) == 33, 2);

        // fees = 1 → admin withdraws to own balance
        split::withdraw_fees(admin, admin_addr);
        assert!(split::view_balance(admin_addr, signer::address_of(admin)) == 1, 3);

        // recipient withdraw example (a2)
        split::withdraw(a2, admin_addr);
        assert!(split::view_balance(admin_addr, signer::address_of(a2)) == 0, 4);
    }
}
