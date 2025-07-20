
## 📄 `README_EN.md` – Englischsprachige Projektübersicht

```markdown
# Proxmox LXC Container Creator

A modular, maintainable, and user-friendly Bash-based toolkit for securely creating and configuring LXC containers on Proxmox VE.

---

## ✨ Features

- Interactive setup via whiptail (TUI)
- Multilingual: English and German (auto-selection)
- Optional hostname via CLI argument (`--hostname`)
- SSH key import via public key comment
- Static IPv4 / IPv6 configuration
- Auto-configuration of locales and timezone (de_DE.UTF-8, Europe/Berlin)
- Post-install APT package updates
- Automatic cloning of a dotfiles GitHub repo for personalization
- Final CLI summary of all container settings
- Fully modular architecture using `.func` files

---

## 🗂 Project Structure

```
proxmox-lxc-creator/
├── create_ct_install.sh    # Main startup script
├── *.func                  # Individual bash logic modules
├── .gitignore              # Git exclusions
├── LICENSE                 # MIT License
└── README.md               # Mixed-language overview
```

---

## 🔧 Quick Installation

```
git clone https://github.com/stony64/proxmox-lxc-creator.git
cd ~/proxmox-lxc.creator
chmod +x create_ct_install.sh
```

Ensure `bash >= 4`, `whiptail`, and `pct` are available on your Proxmox host.
Templates must be present in your configured `TEMPLATE_PATH`.

---

## ▶️ Usage

```
sudo ./create_ct_install.sh
```

Optional:

```
sudo ./create_ct_install.sh --hostname myct01
sudo ./create_ct_install.sh --dry-run
```

---

## ⚙️ Customization

- Adjust `.func` modules for your own logic
- Plug in your own template directory or SSH setup
- Easily extendable to CI/CD, batch creation, or roles (e.g. dev boxes, web hosts)

---

## 🏷 License

MIT License – see [LICENSE](./LICENSE)

---

## 📫 Support

- [GitHub Issues](https://github.com/stony64/proxmox/issues) for bug reports and feature requests
- Or get in touch directly via GitHub profile

---

**Happy container creating! 🧱**
```
