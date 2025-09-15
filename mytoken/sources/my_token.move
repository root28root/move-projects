module MyToken::coin {

use 0x1::signer;

    /// Resource that represents a simple token
    struct Coin has store { value: u64 }

    const EINSUFFICIENT_BALANCE: u64 = 1;

    /// Mint new tokens
    public fun mint(owner: &signer, amount: u64): Coin {
        Coin { value: amount }
    }

    /// Get balance
    public fun balance(coin: &Coin): u64 {
        coin.value
    }

    /// Transfer tokens
    public fun transfer(from: &mut Coin, amount: u64): Coin {
        assert!(from.value >= amount, EINSUFFICIENT_BALANCE);
        from.value = from.value - amount;
        Coin { value: amount }
    }

    /// Burn tokens
    public fun burn(coin: Coin): u64 {
        let amount = coin.value;
        amount
    }
}
