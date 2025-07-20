# Proxmox LXC Container Creator

Ein modulares Bash-Toolkit zur sicheren und komfortablen Erstellung von LXC-Containern auf Proxmox VE.

---

## 🚀 Eigenschaften

- Interaktive Bedienung über whiptail (TUI)
- Mehrsprachigkeit: Deutsch & Englisch (automatische Auswahl)
- SSH-Key-Integration über Kommentar im `authorized_keys`
- Statische IPv4/IPv6-Konfiguration
- Automatische Einrichtung von Locales & Zeitzone
- Betriebssystem-Update nach Container-Erstellung
- Dotfiles-GitHub-Repo wird automatisch geklont
- Abschlussausgabe mit allen Containerdaten
- Modularer Aufbau: Funktionen in `.func`-Dateien ausgelagert

---

## 📁 Projektstruktur

<pre>
proxmox-lxc-creator/
├── create_ct_install.sh      # Hauptskript
├── *.func                   # Einzelne Funktionsmodule (Bash)
├── docs/
│   └── INSTALL.MD           # Ausführliche Installationsanleitung (DE/EN)
├── .gitignore               # Git-Ausschlüsse
├── LICENSE                  # MIT License
└── README.md                # Diese Datei
</pre>

---

## 🔧 Installation

> ℹ️ **Ausführliche Installationsanleitung (Deutsch & Englisch):**
> Siehe [docs/INSTALL.MD](docs/INSTALL.MD)

Kurzanleitung:
```bash
git clone https://github.com/stony64/proxmox-lxc-creator.git
cd proxmox-lxc-creator
chmod +x create_ct_install.sh
```

---

## ▶️ Verwendung

```bash
sudo ./create_ct_install.sh
```

---

**Viel Erfolg beim Automatisieren
