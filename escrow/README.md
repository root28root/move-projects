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

---
# 🔐 Escrow (Move)

Мини-эскроу без глобального состояния: кошельки, сделка, fund/release/refund.

## 🚀 Deploy & Run (Aptos Devnet)

**Package address:**  
`0xb35962eed27b9a272d82673f2b7a99e7257b7b1a9af02c1a09143dacbaf498bd`

- Publish tx: https://explorer.aptoslabs.com/txn/0xd7e2ec7644357e389586b3d8b838d2035e510b36f81a583bdd14f248a7daf1ce?network=devnet
- Demo tx (entry_demo): https://explorer.aptoslabs.com/txn/0xc9bf98c9990ed8d5373774fdd0d1c0987064cc5d406f7e1576c6688643c07f4b?network=devnet

# Contacts
- Discord: [@rootmhz_](https://discord.com/users/1047911417396875264)
- Telegram: [@Nikolai_Rootmhz](https://t.me/Nikolai_Rootmhz)
- Email: [007rootmhz@gmail.com](mailto:007rootmhz@gmail.com)
- Hire me: [issue form](https://github.com/root28root/move-projects/issues/new?template=hire-me.yml)

