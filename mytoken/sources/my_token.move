module MyToken::coin {
    /// Minimal in-memory coin (no std imports)
    struct Coin has store { value: u64 }

    const EINSUFFICIENT_BALANCE: u64 = 1;

    /// Mint new tokens
    public fun mint(amount: u64): Coin {
        Coin { value: amount }
    }

    /// Read balance
    public fun balance(c: &Coin): u64 { c.value }

    /// Split amount from coin into a new coin
    public fun transfer(from: &mut Coin, amount: u64): Coin {
        assert!(from.value >= amount, EINSUFFICIENT_BALANCE);
        from.value = from.value - amount;
        Coin { value: amount }
    }

    /// Burn coin and return amount
    public fun burn(c: Coin): u64 {
        let v = c.value;
        v
    }
}
