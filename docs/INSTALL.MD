Gerne! Hier sind zwei sinnvoll strukturierte und professionell formulierte Dateien:

## 📄 `docs/Install.md` – Installationsanleitung (🇩🇪 Deutsch / 🇬🇧 English)

```markdown
# 📦 Installation – Proxmox LXC Container Creator

🇩🇪 Diese Anleitung beschreibt die Installation des Bash-Toolkits auf einem Proxmox VE Host.
🇬🇧 This guide explains how to install the Bash toolkit on a Proxmox VE host.

---

## ✅ Voraussetzungen / Requirements

- ❗ Proxmox VE mit aktivem Zugriff als root
  Proxmox VE with root access
- ✅ Paket `whiptail` für Dialoge (in Proxmox enthalten)
  `whiptail` package for interactive dialogs
- 📂 Container-Templates im Standardpfad
  Container templates in the specified path

---

## 🧭 Installation

### 1. Repository klonen / Clone repository

```
git clone https://github.com/stony64/proxmox-lxc-creator.git
cd ~/proxmox-lxc-creator
chmod +x create_ct_install.sh
```

---

### 2. (Optional) Git-Benutzerdaten setzen / Set Git identity

```
git config user.name "Your Name"
git config user.email "you@example.com"
```

---

### 3. Funktionsprüfung / Verify setup

```
ls -1 *.func
bash --version   # Mindestens Bash 4
```

---

## ⚙️ Schnelltest / Quick test

```
sudo ./create_ct_install.sh --dry-run
```

Zeigt eine Vorschau der Einstellungen, ohne einen CT zu erstellen.
Displays a preview of your configuration without actually creating a container.

---
```
