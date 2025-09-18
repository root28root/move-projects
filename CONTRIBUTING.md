# Contributing

Thanks for considering a contribution! This is a Move monorepo (Aptos-first, Sui-friendly).

## Dev Setup
- OS: Linux/macOS or Windows + WSL
- Aptos CLI >= 7.8.0
- `./tools/check.sh` runs build + unit tests for all subprojects.

## Conventions
- Use `0x1::...` imports for stdlib (not `std::` in our code/tests).
- Keep test modules `#[test_only]`.
- Each feature/change must include unit tests (positive + at least one negative).
- Commit messages: short, imperative (e.g. `escrow: add refund test; tighten E_NOT_FUNDED`).

## PR Checklist
- [ ] `./tools/check.sh` is green
- [ ] New/changed logic has tests
- [ ] README updated if public API changed
- [ ] No `{{ADDR}}` placeholders

## Project Map
- `mytoken/` — demo token API
- `escrow/` — deal funding/release
- `simplenft/` — minimal NFT registry
- `minimarket/` — list/buy with fee pool
- `paysplit/` — proportional revenue splitter

## Issue Templates
Use **“💼 Hire me”** for paid tasks. For bugs/features, please describe:
- What happened vs expected
- Module/function
- Minimal repro (unit test or steps)
