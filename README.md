# 🌐 Cloudflare Dynamic DNS Updater[![Hits](https://hits.sh/github.com/micaelATwh3e/cloudflare-ddns.svg)]

A lightweight Bash-based Dynamic DNS updater for Cloudflare.  
This script automatically updates one or more **A‑records** on Cloudflare whenever your public IP changes.  
Ideal for home servers, self‑hosting, VPN endpoints, or any setup running behind a dynamic IP.

---

## ✨ Features

- Supports **multiple DNS records** on the same domain  
- Keeps Cloudflare **proxied (orange cloud)** or **unproxied (grey cloud)** per record  
- Only updates when your IP actually changes  
- Uses Cloudflare’s modern **API Token** authentication  
- Optional **systemd service + timer** for automatic updates  
- Works on any Linux system with Bash + curl

---

## 📦 Requirements

- Cloudflare account  
- Cloudflare API Token with **Zone → DNS → Edit** permissions  
- Zone ID for your domain  
- Bash + curl installed

---

## 🔧 Setup

Edit the configuration section at the top of the script:

```bash
CF_API_TOKEN="YOUR_API_TOKEN"
CF_ZONE_ID="YOUR_ZONE_ID"

RECORDS=(
    "sub1.example.com true"
    "sub2.example.com false"
    "sub3.example.com true"
)
