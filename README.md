# Move Projects (Aptos Devnet)

[![CI](https://github.com/root28root/move-projects/actions/workflows/move-ci.yml/badge.svg?branch=main)](https://github.com/root28root/move-projects/actions/workflows/move-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
![Move](https://img.shields.io/badge/Move-Aptos%2FSui-blue)

**Hire me:** Move dev for Aptos/Sui — PoCs, mini-audits, porting logic to Move.  
**DM:** @rootmhz • **Email:** 007rootmhz@gmail.com

---

## 👋 About
Move dev (Aptos-first, Sui-friendly). Real contracts with deployments & tests.

## 🚀 Deployed on Devnet
| Project | Folder | Publish | Demo (entry) |
|---|---|---|---|
| **MyToken** | [`mytoken/`](mytoken) | `0xa40edb103423fee591d4947cb15843af4513cfb4b45a9275faa6ea444f2d74d8` | `0x1f0cadf053ac26b3775a9585b53a88c480cd0a3f6d8b9f979a9fb98bae2acdab` |
| **Escrow** | [`escrow/`](escrow) | `0xd7e2ec7644357e389586b3d8b838d2035e510b36f81a583bdd14f248a7daf1ce` | `0xc9bf98c9990ed8d5373774fdd0d1c0987064cc5d406f7e1576c6688643c07f4b` |
| **SimpleNFT** | [`simplenft/`](simplenft) | `0xfe1cbd0b4514deb3c529aee2286a35f3f3f5f177acc7867dcfa428f48305bec4` | `0x279c2d6adcc180f572329e253077f65f9c792cb14a5e9e49b6346540585754f2` |
| **MiniMarketplace** | [`minimarket/`](minimarket) | `0x2143c7502fb75afc1dfe4bd4cf316188fc8656dc4e997e13108c22d3cc770a46` | `0xda2fb28c29d037406aa658a0b5e4e69514d663c22975011674d95a4aec20703f` |

## 📂 Current Projects
- MyToken — basic token contract with mint/transfer/burn  
- Escrow — deposit & release logic (secure transactions)  
- SimpleNFT — NFT minting and transfer with events  
- MiniMarketplace — listing & buying assets with fees  

👉 All projects with code and tests: **this repo**.

## 🧪 How to run locally
Requirements: Windows + WSL (Kali), **Aptos CLI 7.8.0**, profile `default`, network `devnet`.

```bash
# Check Aptos profile/network
aptos config show-profiles

# Repo-wide build & unit tests (all subprojects)
./tools/check.sh

# Or per project
cd minimarket && aptos move compile && aptos move test --filter .

🛠 Tech Stack

Move (Sui/Aptos), Rust basics, Git & GitHub, smart-contracts design, testing & documentation.

🎯 Goals

Deliver production-ready smart contracts on Move; contribute to Aptos/Sui (bounties, grants, collaborations).

Need a PoC , mini-audit, or port to Move?
DM @rootmhz • Email 007rootmhz@gmail.com
