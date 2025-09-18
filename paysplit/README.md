# PaySplit — proportional revenue splitter (Aptos Move)

> Simple, gas-friendly splitter: deposits are split among recipients by fixed integer shares.  
> Integer remainder (from floor division) is accumulated as **fees** for the admin.

- **Module:** `PaySplit::split`
- **Status:** compiles; CI green
- **Use cases:** payout royalties, split protocol revenue, team distributions

---

## Data model

- `struct Splitter {`
  - `admin: address` — package address that owns the splitter
  - `recipients: vector<address>` — payout accounts
  - `shares: vector<u64>` — integer weights per recipient
  - `total_shares: u64` — sum(shares), precomputed
  - `balances: vector<Balance>` — internal pending balances
  - `fees_accumulated: u64` — remainder bucket (see math below)
- `struct Balance { owner: address, amount: u64 }`

**Math:** for each deposit `amount`, each recipient `i` gets  
`part_i = (amount * shares[i]) / total_shares` (floor division).  
Remainder `amount - sum(part_i)` goes to `fees_accumulated` and can later be claimed by admin.

---

## Public API (entries)

- `init(admin: &signer, recipients: vector<address>, shares: vector<u64>)`
  - One-time init stored under `address_of(admin)`.
  - Fails if `recipients.is_empty()`, length mismatch, or already initialized.

- `deposit(payer: &signer, admin_addr: address, amount: u64)`
  - Splits `amount` to recipients’ internal balances; pushes remainder to `fees_accumulated`.

- `withdraw(rcpt: &signer, admin_addr: address)`
  - Sets caller’s internal balance to `0` (demo accounting). You can wire real coin/NFT logic later.

- `withdraw_fees(admin: &signer, admin_addr: address)`
  - Moves `fees_accumulated` into admin’s internal balance. Only admin may call.

- `view_balance(admin_addr: address, owner: address): u64`
  - Read internal balance for any address.

**Error codes**
- `E_ALREADY_INIT = 1`, `E_EMPTY = 2`, `E_LEN_MISMATCH = 3`, `E_NOT_ADMIN = 4`

---

## Quick start (local)

```bash
# 1) Compile & run unit tests (if any)
cd paysplit
aptos move compile
aptos move test --filter .

# 2) Publish on devnet (from your Aptos profile)
aptos move publish --assume-yes

# Copy the published package address (we'll call it <PKG>)
# 3) Initialize splitter (example: 3 recipients with shares 50/30/20)
aptos move run \
  --function-id <PKG>::split::init \
  --args 'vector<address>:@0xA,@0xB,@0xC' 'vector<u64>:50,30,20'

# 4) Deposit 100 (splits to 50/30/20; remainder 0)
aptos move run \
  --function-id <PKG>::split::deposit \
  --args "address:<PKG>" "u64:100"

# 5) Admin converts remainder to balance (useful for small deposits with remainder)
aptos move run \
  --function-id <PKG>::split::withdraw_fees \
  --args "address:<PKG>"

# 6) Read balances (from a script or view; here conceptual)
# view_balance(<PKG>, @0xA) == 50, @0xB == 30, @0xC == 20


## Contacts
- Discord: [@rootmhz_](https://discord.com/users/1047911417396875264)
- Telegram: [@Nikolai_Rootmhz](https://t.me/Nikolai_Rootmhz)
- Email: [007rootmhz@gmail.com](mailto:007rootmhz@gmail.com)
- Hire me: [issue form](https://github.com/root28root/move-projects/issues/new?template=hire-me.yml)
