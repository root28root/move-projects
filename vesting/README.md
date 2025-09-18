# Vesting — linear time-based vesting (Aptos Move)

**Модуль:** `Vesting::vesting`  
**Статус:** компилируется; CI зелёный; есть юнит-тесты  
**Юзкейсы:** эмиссия и разлок токенов по времени, тим-вестинг, инвест-расписания

---

## Идея
Простейший вестинг с **линейным разлоком** между `[start, end]`. Денежной логики тут нет — это **учётная модель**: всё считается во внутренних числовых балансах (u64), чтобы было легко интегрировать в реальный токен позже.

Формула:
vested(now) =
0, if now <= start
total, if now >= end
floor(total * (now-start) / (end-start)), otherwise

claimable(now) = vested(now) - already_claimed

## Данные
- `struct Schedule { ben: address, total: u64, start: u64, end: u64, claimed: u64, active: bool }`
- `vector<Schedule>` — хранится под адресом админа (инициатора)
- Внутренние «балансы» по адресам для демо-учёта: `view_balance(admin_addr, owner) -> u64`

---

## Публичный API (entries)
- `entry init(admin: &signer)`
  - Однократная инициализация хранилища под `address_of(admin)`.

- `entry create(admin: &signer, ben: address, total: u64, start: u64, end: u64)`
  - Добавляет расписание. Первый созданный идёт под `id = 0`, далее по инкременту.
  - Валидация времени: `start < end`.

- `entry claim(ben: &signer, admin_addr: address, id: u64, now: u64)`
  - Клеймит дельту `claimable(now)` для расписания `id` и увеличивает внутренний баланс бенефициара.
  - Проверяет, что `ben` == назначенный бенефициар.

- `fun view_balance(admin_addr: address, owner: address): u64`
  - Возвращает внутренний «накопленный» баланс адреса в рамках хранилища `admin_addr`.

> ⚠️ Денежные переводов нет — это осознанно. В реальном проекте сюда можно подвязать  `Coin`/трансфер NFT или экспортировать учтённую величину в другой модуль.

---

## Errors (major)
- creation with an invalid time (e.g., `start >= end`)
- labels non-beneficiary
- accessing a non-existent schedule/uninitialized storage

---

## Unit tests (`tests/vesting_tests.move`)
- **Линейный разлок**: последовательные клеймы увеличивают баланс до `total`.
- **Bad time**: создание с неправильным временем падает.
- **Wrong beneficiary**: клейм не тем адресом падает.

---

## Quick start (локально)

```bash
cd vesting
aptos move compile
aptos move test --filter .

## Contacts
- Discord: [@rootmhz_](https://discord.com/users/1047911417396875264)
- Telegram: [@Nikolai_Rootmhz](https://t.me/Nikolai_Rootmhz)
- Email: [007rootmhz@gmail.com](mailto:007rootmhz@gmail.com)
- Hire me: [issue form](https://github.com/root28root/move-projects/issues/new?template=hire-me.yml)
