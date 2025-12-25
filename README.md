🌐 Cloudflare Dynamic DNS Updater (Bash + systemd)
A lightweight, Arch‑friendly Dynamic DNS updater for Cloudflare.
This script automatically updates one or more A‑records on Cloudflare whenever your public IP changes.
Perfect for home servers, self‑hosting, VPN endpoints, or anything running behind a dynamic IP.

✨ Features
Supports multiple DNS records on the same domain

Keeps Cloudflare proxied (orange cloud) or unproxied (grey cloud) per record

Only updates when your IP actually changes

Uses Cloudflare’s modern API Token authentication

Includes optional systemd service + timer for automatic updates

Works on Arch Linux and any Linux distro with Bash + curl

📦 Requirements
Cloudflare account

API Token with Zone → DNS → Edit permissions

Zone ID for your domain

Bash + curl (installed by default on most systems)

🔧 Installation
Clone or download this repository, then make the script executable:

bash
chmod +x cloudflare-ddns.sh
Edit the configuration section at the top of the script:

bash
CF_API_TOKEN="YOUR_API_TOKEN"
CF_ZONE_ID="YOUR_ZONE_ID"
RECORDS=(
    "sub1.example.com true"
    "sub2.example.com false"
    ...
)
Each entry is:

Kod
"hostname proxied"
Where proxied is either:

true  → Cloudflare orange cloud

false → DNS only (grey cloud)

▶️ Manual Run
You can test the script manually:

bash
./cloudflare-ddns.sh
If your IP changed, it will update all configured DNS records.

⏱️ Optional: systemd Automation
Create a service:

ini
# /etc/systemd/system/cloudflare-ddns.service
[Unit]
Description=Cloudflare Dynamic DNS Updater

[Service]
Type=oneshot
ExecStart=/path/to/cloudflare-ddns.sh
Create a timer:

ini
# /etc/systemd/system/cloudflare-ddns.timer
[Unit]
Description=Run Cloudflare DDNS every 5 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
Enable and start:

bash
sudo systemctl enable --now cloudflare-ddns.timer
📝 Logging (optional)
You can pipe output to a log file by modifying the service:

ini
ExecStart=/path/to/cloudflare-ddns.sh >> /var/log/cloudflare-ddns.log 2>&1
📄 License
MIT License — feel free to use, modify, and share.

If you want, I can also generate:

A version with IPv6 (AAAA) support

A Dockerized version

A more advanced README with badges, screenshots, or examples

Just tell me what style you want.
