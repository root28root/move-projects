module Escrow::escrow_tests {
    use std::signer;
    use Escrow::escrow;

    #[test]
    public fun full_success_flow() {
        let buyer = signer::spec_test_signer();
        let seller = signer::spec_test_signer();

        let mut bw = escrow::new_wallet(&buyer);
        let mut sw = escrow::new_wallet(&seller);

        // Пополняем баланс покупателя и создаём сделку
        escrow::deposit(&buyer, &mut bw, 150);
        let mut d = escrow::create(&buyer, signer::address_of(&seller), 100);

        // Вносим средства и выплачиваем продавцу
        escrow::fund(&buyer, &mut bw, &mut d);
        assert!(escrow::balance(&bw) == 50, 0);

        escrow::release(&seller, &mut sw, &mut d);
        assert!(escrow::balance(&sw) == 100, 1);
    }

    #[test]
    public fun refund_flow() {
        let buyer = signer::spec_test_signer();
        let seller = signer::spec_test_signer();

        let mut bw = escrow::new_wallet(&buyer);
        let mut sw = escrow::new_wallet(&seller);

        escrow::deposit(&buyer, &mut bw, 100);
        let mut d = escrow::create(&buyer, signer::address_of(&seller), 100);

        escrow::fund(&buyer, &mut bw, &mut d);
        escrow::refund(&buyer, &mut bw, &mut d);

        assert!(escrow::balance(&bw) == 100, 2);
        assert!(escrow::balance(&sw) == 0, 3);
    }
}
