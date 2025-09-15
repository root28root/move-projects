module MyToken::coin {
    use 0x1::signer;

    /// Simple in-memory coin (educational)
    struct Coin has store { value: u64 }

    const EINSUFFICIENT_BALANCE: u64 = 1;

    public fun mint(_owner: &signer, amount: u64): Coin {
        Coin { value: amount }
    }

    public fun balance(coin: &Coin): u64 {
        coin.value
    }

    public fun transfer(from: &mut Coin, amount: u64): Coin {
        assert!(from.value >= amount, EINSUFFICIENT_BALANCE);
        from.value = from.value - amount;
        Coin { value: amount }
    }

    public fun burn(coin: Coin): u64 {
        let amount = coin.value;
        amount
    }
}
