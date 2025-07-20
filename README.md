```markdown
# Proxmox LXC Container Creator

Ein modulares, wartbares und interaktiv bedienbares Bash-Toolkit zur sicheren und automatisierten Erstellung von **LXC-Containern auf Proxmox VE-Hosts**.

---

## 🚀 Eigenschaften

- ✅ Interaktive Bedienung über whiptail-TUI (Text User Interface)
- 🌐 Mehrsprachigkeit: Deutsch & Englisch (automatische Auswahl)
- 🔐 SSH-Key-Integration über Kommentar im `authorized_keys`
- 🌍 Statische IP-Adressen-Vergabe (IPv4 und IPv6) per Benutzereingabe
- 🇩🇪 Automatische Konfiguration von Locales & Zeitzone (de_DE.UTF-8, Europe/Berlin)
- 🛠️ Betriebssystem-Update (apt) direkt nach Container-Erstellung
- 💾 Dotfiles-GitHub-Repo wird automatisch geklont (z. B. für Shell-Setup)
- 📋 Abschlussausgabe mit allen Containerdaten (übersichtlich für CLI/Doku)
- 🧩 Übergabe von Parametern wie `--hostname` für Automatisierung
- ♻️ Modularer Aufbau: Funktionen sind in logischen `.func`-Dateien ausgelagert

---

## 📁 Projektstruktur

```
proxmox-lxc-creator/
├── create_ct_install.sh      # Hauptskript (Startpunkt)
├── translation.func          # Mehrsprachige Textausgaben (DE/EN)
├── logging.func              # Logging & Fehlerausgabe
├── cli.func                  # CLI-Parameterverarbeitung
├── input.func                # Hostname, Password, Template-Auswahl
├── network.func              # IP-Adressen & Netze
├── ssh.func                  # SSH-Key-Erkennung & Integration
├── container.func            # LXC-Erstellung und Start
├── system.func               # Locales, Zeitzone, Updates
├── dotfiles.func             # Git-Klon-Logik für eigene Konfigurationen
├── summary.func              # Abschlussausgabe
├── .gitignore                # Ignorierte Dateien (Logs etc.)
├── LICENSE                   # MIT License
└── README.md                 # Diese Datei
```

---

## 🔧 Installation

1. Repository auf dem Proxmox-Host klonen:

```
git clone https://github.com/stony64/proxmox.git /opt/scripts/proxmox/install
cd /opt/scripts/proxmox/install
chmod +x create_ct_install.sh
```

2. Abhängigkeiten prüfen (müssen vorhanden sein):

- Proxmox VE System mit `pct`
- Bash ≥ 4.x
- `whiptail` (für Dialog)
- Container-Templates im angegebenen Verzeichnis (`TEMPLATE_PATH`)

3. (Optional) Git konfigurieren:
   ```
   git config user.name "Dein Name"
   git config user.email "dein@domain.de"
   ```

---

## ▶️ Verwendung

### 🧑‍💻 Interaktiver Modus

```
sudo ./create_ct_install.sh
```

### 🔧 Mit optionalem Hostname

```
sudo ./create_ct_install.sh --hostname test01
```

### 🧐 Vorschau (Dry-Run)

```
sudo ./create_ct_install.sh --dry-run
```

---

## 🛠️ Anpassung & Erweiterung

- Verwende eigene Container-Tags, Templates oder Netzkonfigurationen.
- Die `.func`-Dateien sind logisch gegliedert und können einzeln angepasst werden.
- Typisch erweiterbar für:
  - Presets (z. B. Webserver, Dev Box)
  - Massenanlagen (per Batch-Datei)
  - Integration in CI/CD oder Ansible
- Eigene Dotfiles: GitHub-URL in `dotfiles.func` anpassen

---

## 🏷️ Lizenz

Dieses Projekt steht unter der **MIT License**.  
→ Siehe [LICENSE](./LICENSE) für weitere Informationen.

---

## 📫 Support

**Issues, Feature-Wünsche oder Fehler melden?**

→ Nutze das [Issue-Board auf GitHub](https://github.com/stony64/proxmox/issues)  
→ Oder sende eine Nachricht direkt an den Maintainer

---

**Viel Erfolg beim Automatisieren deiner Container!**
```