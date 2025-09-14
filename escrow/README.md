# 🔒 Escrow (Move)

Educational escrow contract in **Move**.  
Implements funding, release to seller, and refund to buyer.

---

## Features
- `create` — initialize deal (buyer, seller, amount)
- `fund` — buyer funds the deal (escrow)
- `release` — seller receives funds
- `refund` — buyer gets refund

> Uses a simple in-module `Wallet` resource for demonstration and tests.

---

## Build
```bash
sui move build

---
## Test
```bash
sui move test

---
## Notes

This is a learning project in pure Move (MoveStdlib).

No chain-specific framework used here (Sui/Aptos integration will be in separate projects).
