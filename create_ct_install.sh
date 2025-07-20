#!/usr/bin/env bash
###############################################################################
# Proxmox LXC Container Creator – Hauptskript
# Version:    2.7.5
# Datum:      2025-07-20
#
# Beschreibung:
#   Steuert modular die automatisierte Erstellung und Konfiguration von
#   Proxmox-LXC-Containern:
#     - Mehrsprachiges TUI (whiptail) via translation.func
#     - Logging & sichere Fehlerbehandlung
#     - Statische/reservierte IP-Vergabe mit Validierung
#     - SSH-Key-Integration
#     - Dotfiles-GitHub-Synchronisation
#     - Lokalisierung, Zeitzone & Systemupdate
#     - Vollständige CLI-Parameter-Unterstützung (z. B. --hostname)
#     - Abschlusszusammenfassung der relevanten Containerdaten
#
#   Funktionen und Logik sind in *.func-Dateien modularisiert für Wartbarkeit.
#
###############################################################################

set -euo pipefail
trap 'log_error "FEHLER in Zeile $LINENO"; exit 2' ERR

################################################################################
# 1 – Konfiguration & globale Variablen
################################################################################

readonly STORAGE="FP1000GB"
readonly TEMPLATE_PATH="/mnt/FP1000GB/template/cache"
readonly LOGFILE="/opt/scripts/proxmox/lxc_create_$(date +'%Y%m%d_%H%M%S').log"
readonly NET_BRIDGE="vmbr2"
readonly BASE_IPV4="192.168.10."
readonly BASE_IPV6="fd00:1234:abcd:10::"
readonly GATEWAY_IPV4="192.168.10.1"
readonly GATEWAY_IPV6="fd00:1234:abcd:10:3ea6:2fff:fe65:8fa7"

# Diese Variablen werden im Ablauf überschrieben/gesetzt:
CT_ID="" CT_HOSTNAME="" CT_PASSWORD="" CT_CORES="" CT_MEMORY="" ROOTFS_SIZE=""
TEMPLATE_FILE="" OSTEMPLATE="" OSType="" SSH_PUBKEY="" LAPTOP_KEY_COMMENT=""
CT_IPV4="" CT_IPV6="" PARAM_HOSTNAME=""

################################################################################
# 2 – Laden aller Funktionsmodule (modular, wartbar)
################################################################################

# [Deutsch/Englisch] Sprachsystem laden (als erstes!)
source "$(dirname "$0")/translation.func"
load_translations

# Logging
source "$(dirname "$0")/logging.func"

# CLI-Parameter-Verarbeitung (z. B. --hostname)
source "$(dirname "$0")/cli.func"

# Interaktive Benutzereingaben (Hostname, Passwort, Template usw.)
source "$(dirname "$0")/input.func"

# Netzwerk: IP-Abfrage, Oktett-Validierung
source "$(dirname "$0")/network.func"

# SSH-Kommentar, Key-Operationen
source "$(dirname "$0")/ssh.func"

# Erstellung und Start (pct create/start, Tags setzen)
source "$(dirname "$0")/container.func"

# Systempflege: Locales, Zeitzone, apt-Update
source "$(dirname "$0")/system.func"

# Dotfiles aus GitHub klonen/pullen
source "$(dirname "$0")/dotfiles.func"

# Abschluss: Zusammenfassung der Containerdaten
source "$(dirname "$0")/summary.func"

################################################################################
# 3 – Hauptlogik: Modularer Workflow
################################################################################

main() {
    parse_args "$@"
    check_root
    select_mode
    find_next_ctid

    input_hostname
    input_password
    select_template
    detect_ostype_from_template
    input_rootfs_size
    input_resources
    get_container_ip

    ask_for_laptop_key_comment
    extract_laptop_key

    # Dry-Run ggf. frühzeitig beenden
    [[ "${1:-}" == "--dry-run" ]] && dry_run_preview

    prepare_ssh_key_prestart
    create_container
    finalize_ssh_key_after_start
    configure_locales
    update_container
    clone_dotfiles_in_container
    print_summary
}

main "$@"
