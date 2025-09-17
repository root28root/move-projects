> **Hire me:** Move dev for Aptos/Sui — PoCs, mini-audits, porting logic to Move.  
> DM: @rootmhz • Email: 007rootmhz@gmail.com
[![CI](https://github.com/root28root/move-projects/actions/workflows/move-ci.yml/badge.svg?branch=main)](…)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Move](https://img.shields.io/badge/Move-Aptos%2FSui-blue)

# 👋 Hi, I'm Rootmhz

🚀 **Move Developer (Sui & Aptos)**  
🔹 Focused on Web3, DeFi, and blockchain infrastructure  
🔹 Building smart contracts and dApps with Move language  
🔹 Currently developing a portfolio of practical projects  

---

## 📂 Current Projects
- **MyToken** — basic token contract with mint/transfer/burn  
- **Escrow** — deposit & release logic (secure transactions)  
- **SimpleNFT** — NFT minting and transfer with events  
- **MiniMarketplace** — listing & buying assets with fees  

👉 All projects with code and tests: [Move Projects Repo](https://github.com/yourusername/move-projects)

---

## 🛠 Tech Stack
- Move (Sui / Aptos)
- Rust basics
- Git & GitHub
- Smart contracts design
- Testing & documentation

---

## 🎯 Goals
- Deliver production-ready smart contracts on Move  
- Contribute to Sui & Aptos ecosystem (bounties, grants, collaborations)  
- Build a strong portfolio of real-world dApps  

---
✨ *Actively building smart contracts on Move and open to bounties, grants, and collaborations.*

![Move CI](https://github.com/root28root/move-projects/actions/workflows/move-ci.yml/badge.svg)



# Move Projects (Aptos Devnet)

[![CI](https://github.com/root28root/move-projects/actions/workflows/move-ci.yml/badge.svg?branch=main)](https://github.com/root28root/move-projects/actions/workflows/move-ci.yml)

## 👋 About
Move dev (Aptos-first, Sui-friendly). Real contracts with deployments & tests.

---

## 🚀 Deployed on Devnet
- **MyToken (`mytoken/`)**  
  Publish: `0xa40edb103423fee591d4947cb15843af4513cfb4b45a9275faa6ea444f2d74d8`  
  Demo (entry): `0x1f0cadf053ac26b3775a9585b53a88c480cd0a3f6d8b9f979a9fb98bae2acdab`

- **Escrow (`escrow/`)**  
  Publish: `0xd7e2ec7644357e389586b3d8b838d2035e510b36f81a583bdd14f248a7daf1ce`  
  Demo (entry): `0xc9bf98c9990ed8d5373774fdd0d1c0987064cc5d406f7e1576c6688643c07f4b`

- **SimpleNFT (`simplenft/`)**  
  Publish: `0xfe1cbd0b4514deb3c529aee2286a35f3f3f5f177acc7867dcfa428f48305bec4`  
  Demo (entry): `0x279c2d6adcc180f572329e253077f65f9c792cb14a5e9e49b6346540585754f2`

- **MiniMarketplace (`minimarket/`)**  
  Publish: `0x2143c7502fb75afc1dfe4bd4cf316188fc8656dc4e997e13108c22d3cc770a46`  
  Demo (entry): `0xda2fb28c29d037406aa658a0b5e4e69514d663c22975011674d95a4aec20703f`

---

## 🧪 How to run locally
Requirements: Windows + WSL (Kali), **Aptos CLI 7.8.0**, profile `default`, network `devnet`.

```bash
# Проверка профиля/сети
aptos config show-profiles

# Сборка/публикация/запуск (внутри выбранного проекта)
cd <project-dir>
aptos move compile
aptos move publish --assume-yes
aptos move run --function-id <ADDR>::<MODULE>::<ENTRY>

----

## Quick start (local)

```bash
# проверить профиль Aptos
aptos config show-profiles

# репо-чек (собрать и прогнать юнит-тесты во всех подпроектах)
./tools/check.sh

# вручную по проекту
cd minimarket && aptos move compile && aptos move test --filter .

