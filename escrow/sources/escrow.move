module Escrow::escrow {
    use std::signer;

    /// Error codes
    const E_ALREADY_FUNDED: u64 = 1;
    const E_NOT_FUNDED: u64   = 2;
    const E_COMPLETED: u64    = 3;
    const E_INSUFFICIENT: u64 = 4;
    const E_NOT_BUYER: u64    = 5;
    const E_NOT_SELLER: u64   = 6;

    /// Simple wallet resource for demo/tests (no global storage)
    struct Wallet has store { balance: u64 }

    /// Deal state kept in-memory for demo
    struct Deal has store {
        buyer: address,
        seller: address,
        amount: u64,
        funded: bool,
        completed: bool,
    }

    public fun new_wallet(_owner: &signer): Wallet { Wallet { balance: 0 } }

    public fun deposit(_owner: &signer, w: &mut Wallet, amount: u64) {
        w.balance = w.balance + amount;
    }

    public fun balance(w: &Wallet): u64 { w.balance }

    public fun create(buyer: &signer, seller: address, amount: u64): Deal {
        Deal {
            buyer: signer::address_of(buyer),
            seller,
            amount,
            funded: false,
            completed: false,
        }
    }

    public fun fund(buyer: &signer, buyer_wallet: &mut Wallet, d: &mut Deal) {
        assert!(signer::address_of(buyer) == d.buyer, E_NOT_BUYER);
        assert!(!d.funded, E_ALREADY_FUNDED);
        assert!(buyer_wallet.balance >= d.amount, E_INSUFFICIENT);
        buyer_wallet.balance = buyer_wallet.balance - d.amount;
        d.funded = true;
    }

    public fun release(seller: &signer, seller_wallet: &mut Wallet, d: &mut Deal) {
        assert!(signer::address_of(seller) == d.seller, E_NOT_SELLER);
        assert!(d.funded, E_NOT_FUNDED);
        assert!(!d.completed, E_COMPLETED);
        seller_wallet.balance = seller_wallet.balance + d.amount;
        d.completed = true;
    }

    public fun refund(buyer: &signer, buyer_wallet: &mut Wallet, d: &mut Deal) {
        assert!(signer::address_of(buyer) == d.buyer, E_NOT_BUYER);
        assert!(d.funded, E_NOT_FUNDED);
        assert!(!d.completed, E_COMPLETED);
        buyer_wallet.balance = buyer_wallet.balance + d.amount;
        d.completed = true;
    }
}
