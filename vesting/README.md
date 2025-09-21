# Vesting — linear token vesting (Aptos Move)

Simple, gas-friendly linear vesting with on-chain accounting of claimed amounts.

**Module:** `Vesting::vesting`  
**Status:** compiles; CI green  
**Use cases:** team/seed vesting, grants, OTC unlocks

## Data model
struct Schedule {
beneficiary: address,
total: u64,
start: u64,
end: u64,
claimed: u64,
}
struct Balance { owner: address, amount: u64 }
struct State { admin, schedules, balances, initialized }

`vested_at(now)` = linear piecewise (0 → total).  
`claimable_at(now)` = `vested_at - claimed` (floor math, no remainders).

## Public API
- `entry init(admin)` — one-time init under `address_of(admin)`.
- `entry create(admin, beneficiary, total, start, end)` — append schedule.
- `entry claim(ben, admin_addr, sched_id, now)` — claim to internal balance.
- `view_balance(admin_addr, owner)` — read internal balance (for demos/tests).

Errors:  
`E_ALREADY_INIT=1, E_NOT_INIT=2, E_BAD_TIME=3, E_NOT_BENEFICIARY=4, E_BAD_ID=5, E_NOTHING_TO_CLAIM=6`.

## Devnet
- **Package address:** `0x225b...5278`
- **Publish tx:** `0xedfb5d7e52...b62c2`
- **Demo tx (entry_demo):** `0xc74e87de5f...b4f8`

## Quick start
```bash
# publish (from your Aptos profile)
aptos move publish --assume-yes

# init
aptos move run --function-id <PKG>::vesting::init

# create schedule (total=100, [0..100]) for <PKG>
aptos move run --function-id <PKG>::vesting::create \
  --args address:<PKG> u64:100 u64:0 u64:100

# claims at t=30,80,200
aptos move run --function-id <PKG>::vesting::claim --args address:<PKG> u64:0 u64:30
aptos move run --function-id <PKG>::vesting::claim --args address:<PKG> u64:0 u64:80
aptos move run --function-id <PKG>::vesting::claim --args address:<PKG> u64:0 u64:200

Inspect via REST
REST="https://fullnode.devnet.aptoslabs.com"
curl -s "$REST/v1/accounts/<PKG>/resource/<PKG>::vesting::State" | jq .
curl -s "$REST/v1/accounts/<PKG>/resource/<PKG>::vesting::State" \
  | jq -r '.data.schedules[] | {beneficiary,total,start,end,claimed}'

Contacts

Discord: @rootmhz_

Telegram: @Nikolai_Rootmhz

Email: 007rootmhz@gmail.com

Hire me: issue form
