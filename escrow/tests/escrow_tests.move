module Escrow::escrow_tests {
    use Escrow::escrow;

    const BUYER: address = @0x1;
    const SELLER: address = @0x2;

    #[test]
    public fun full_success_flow() {
        let bw = escrow::new_wallet();
        let sw = escrow::new_wallet();

        escrow::deposit(&mut bw, 150);
        let d = escrow::create(BUYER, SELLER, 100);

        escrow::fund(BUYER, &mut bw, &mut d);
        assert!(escrow::balance(&bw) == 50, 0);

        escrow::release(SELLER, &mut sw, &mut d);
        assert!(escrow::balance(&sw) == 100, 1);
    }

    #[test]
    public fun refund_flow() {
        let bw = escrow::new_wallet();
        let sw = escrow::new_wallet();

        escrow::deposit(&mut bw, 100);
        let d = escrow::create(BUYER, SELLER, 100);

        escrow::fund(BUYER, &mut bw, &mut d);
        escrow::refund(BUYER, &mut bw, &mut d);

        assert!(escrow::balance(&bw) == 100, 2);
        assert!(escrow::balance(&sw) == 0, 3);
    }
}
