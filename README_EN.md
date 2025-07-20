# Proxmox LXC Container Creator

A modular Bash toolkit for secure and user-friendly creation of LXC containers on Proxmox VE.

---

## ✨ Features

- Interactive setup via whiptail (TUI)
- Multilingual: English & German (auto-selection)
- SSH key import via public key comment
- Static IPv4/IPv6 configuration
- Automatic setup of locales & timezone
- Post-install OS updates
- Automatic cloning of a dotfiles GitHub repo
- Final summary of all container settings
- Modular architecture: logic in `.func` files

---

## 🗂 Project Structure

<pre>
proxmox-lxc-creator/
├── create_ct_install.sh    # Main startup script
├── *.func                  # Individual bash logic modules
├── docs/
│   └── INSTALL.MD          # Detailed installation guide (EN/DE)
├── .gitignore              # Git exclusions
├── LICENSE                 # MIT License
└── README_EN.md            # This file
</pre>

---

## 🔧 Installation

> ℹ️ **For a detailed installation guide (English & German):**
> See [docs/INSTALL.MD](docs/INSTALL.MD)

Quick start:
```bash
git clone https://github.com/stony64/proxmox-lxc-creator.git
cd proxmox-lxc-creator
chmod +x create_ct_install.sh
```

---

## ▶️ Usage

```bash
sudo ./create_ct_install.sh
```

---

**Happy automating
