Simple in-memory marketplace: `init(admin, fee_bps)`, `list(item_id, price)`, `buy(item_id)`, `withdraw_fees()`.
No external deps except MoveStdlib (vendored as submodule).

## Deployed on Devnet
- Account: https://explorer.aptoslabs.com/account/0x225b149b3bfc3caabcbb7edf8c855636c0c00131226127e35545556aaf325278?network=devnet
- Publish tx: https://explorer.aptoslabs.com/txn/0x2143c7502fb75afc1dfe4bd4cf316188fc8656dc4e997e13108c22d3cc770a46?network=devnet
- Demo tx (entry_demo): https://explorer.aptoslabs.com/txn/0xda2fb28c29d037406aa658a0b5e4e69514d663c22975011674d95a4aec20703f?network=devnet

## How to run locally
```bash
# WSL/WSL2, Aptos CLI 7.8.0, profile=default (Devnet), address=0x225b...5278
cd minimarket

# compile / publish / run
aptos move compile
aptos move publish --assume-yes
aptos move run --function-id 0x225b149b3bfc3caabcbb7edf8c855636c0c00131226127e35545556aaf325278::minimarket::entry_demo
