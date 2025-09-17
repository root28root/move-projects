#[test_only]
module Escrow::escrow_tests {
    use Escrow::escrow;

    const BUYER: address = @0x1;
    const SELLER: address = @0x2;

    #[test]
    public entry fun test_happy_flow() {
        let bw = escrow::new_wallet();
        let sw = escrow::new_wallet();

        escrow::deposit(&mut bw, 150);
        let d = escrow::create(BUYER, SELLER, 100);

        escrow::fund(BUYER, &mut bw, &mut d);
        escrow::release(SELLER, &mut sw, &mut d);

        assert!(escrow::balance(&bw) == 50, 0);
        assert!(escrow::balance(&sw) == 100, 1);

        // Поглощаем ресурсы
        escrow::destroy_deal_for_test(d);
        escrow::destroy_wallet_for_test(bw);
        escrow::destroy_wallet_for_test(sw);
    }

    // Негатив: не тот покупатель на fund -> E_NOT_BUYER = 5
    #[test]
    #[expected_failure(abort_code = 5, location = Escrow::escrow)]
    public entry fun test_fund_wrong_buyer_fails() {
        let bw = escrow::new_wallet();
        let d = escrow::create(BUYER, SELLER, 10);
        escrow::deposit(&mut bw, 10);
        escrow::fund(@0xDEAD, &mut bw, &mut d);
        escrow::destroy_deal_for_test(d);
        escrow::destroy_wallet_for_test(bw);
    }

    // Негатив: release до fund -> E_NOT_FUNDED = 2
    #[test]
    #[expected_failure(abort_code = 2, location = Escrow::escrow)]
    public entry fun test_release_not_funded_fails() {
        let sw = escrow::new_wallet();
        let d = escrow::create(BUYER, SELLER, 10);
        escrow::release(SELLER, &mut sw, &mut d);
        escrow::destroy_deal_for_test(d);
        escrow::destroy_wallet_for_test(sw);
    }
}
