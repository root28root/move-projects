#[test_only]
module 0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd::vesting_tests {
    use Vesting::vesting;

    #[test(admin = @0xA, ben = @0xB)]
    public entry fun test_linear_release_ok(admin: &signer, ben: &signer) {
        let admin_addr = @0xA;
        let ben_addr = @0xB;

        vesting::init(admin);
        vesting::create(admin, ben_addr, /*total*/ 100, /*start*/ 0, /*end*/ 100);

        // t=30 -> 30
        vesting::claim(ben, admin_addr, 0, 30);
        assert!(vesting::view_balance(admin_addr, ben_addr) == 30, 0);

        // t=80 -> стало 80 (доклеймится +50)
        vesting::claim(ben, admin_addr, 0, 80);
        assert!(vesting::view_balance(admin_addr, ben_addr) == 80, 1);

        // t=200 -> стало 100 (доклеймится +20)
        vesting::claim(ben, admin_addr, 0, 200);
        assert!(vesting::view_balance(admin_addr, ben_addr) == 100, 2);
    }

    // Негатив: клеймит не бенефициар -> E_NOT_BENEFICIARY = 4
    #[test(admin = @0xA, ben = @0xB)]
    #[expected_failure(abort_code = 4, location = Vesting::vesting)]
    public entry fun test_wrong_beneficiary_fails(admin: &signer, ben: &signer) {
        let admin_addr = @0xA;
        let ben_addr = @0xB;

        vesting::init(admin);
        vesting::create(admin, ben_addr, 50, 0, 10);
        // Пытается клеймить админ вместо бенефициара
        vesting::claim(admin, admin_addr, 0, 5);
    }

    // Негатив: плохое время в create -> E_BAD_TIME = 3
    #[test(admin = @0xA)]
    #[expected_failure(abort_code = 3, location = Vesting::vesting)]
    public entry fun test_bad_time_fails(admin: &signer) {
        vesting::init(admin);
        vesting::create(admin, @0xB, 100, /*start*/ 50, /*end*/ 50);
    }
}
