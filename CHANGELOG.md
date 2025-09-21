# Changelog

## v0.1.0 — First public snapshot
- ✅ All 4 packages compile on Aptos CLI 7.8.0
- ✅ CI (GitHub Actions) + repo-wide tests `./tools/check.sh`
- ✅ 8 unit tests across packages (2 per project)
- ✅ Devnet publish + demo entry points documented

## v0.2.0 — PaySplit + Vesting, CI hardening
- New: **PaySplit** — proportional revenue splitter (3 unit tests).
- New: **Vesting** — linear vesting with internal balances (3 unit tests).
- Docs: READMEs for paysplit/ and vesting/, root README updated with Devnet links.
- CI: resilient Aptos CLI installer with retries + sanity checks.
