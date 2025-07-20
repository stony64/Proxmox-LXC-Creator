#!/usr/bin/env bash
###############################################################################
# Proxmox LXC Container Creator – Hauptskript / Main Script
# Version:    2.7.5
# Datum:      2025-07-21
#
# Beschreibung (Deutsch):
# Dieses Skript automatisiert die Erstellung und Konfiguration von LXC-
# Containern auf einem Proxmox-Host. Es lädt modular externe Funktionen
# (*.func), nutzt whiptail für interaktive Eingaben und enthält Schritte zur
# Netzwerkkonfiguration, Passwortvergabe, SSH-Key-Setup und Systempflege.
#
# Description (English):
# This script automates the creation and configuration of LXC containers on a
# Proxmox host. It sources modular function files (*.func), uses whiptail for
# interactive input and covers network setup, password management, SSH key
# integration, and system updates.
#
###############################################################################

# Exit bei Fehler, nicht gesetzten Variablen oder Pipefehler
set -euo pipefail
trap 'log_error "FEHLER in Zeile $LINENO / ERROR at line $LINENO"; exit 2' ERR

################################################################################
# 1 – Globale Einstellungen / Global configuration
################################################################################

readonly STORAGE="FP1000GB"
readonly TEMPLATE_PATH="/mnt/FP1000GB/template/cache"

# shellcheck disable=SC2034
LOGFILE="/opt/scripts/proxmox/lxc_create_$(date +'%Y%m%d_%H%M%S').log"
readonly LOGFILE

readonly NET_BRIDGE="vmbr2"
readonly BASE_IPV4="192.168.10."
readonly BASE_IPV6="fd00:1234:abcd:10::"
readonly GATEWAY_IPV4="192.168.10.1"
readonly GATEWAY_IPV6="fd00:1234:abcd:10:3ea6:2fff:fe65:8fa7"

# Laufzeitvariablen / Runtime variables
CT_ID="" CT_HOSTNAME="" CT_PASSWORD="" CT_CORES="" CT_MEMORY="" ROOTFS_SIZE=""
TEMPLATE_FILE="" OSTEMPLATE="" OSType="" SSH_PUBKEY="" LAPTOP_KEY_COMMENT=""
CT_IPV4="" CT_IPV6="" PARAM_HOSTNAME=""

################################################################################
# 2 – Funktionsmodule laden / Load function modules
################################################################################

# shellcheck source=./translation.func
source "$(dirname "$0")/translation.func"
load_translations

# shellcheck source=./security.func
source "$(dirname "$0")/security.func"

# shellcheck source=./logging.func
source "$(dirname "$0")/logging.func"

# shellcheck source=./cli.func
source "$(dirname "$0")/cli.func"

# shellcheck source=./input.func
source "$(dirname "$0")/input.func"

# shellcheck source=./network.func
source "$(dirname "$0")/network.func"

# shellcheck source=./ssh.func
source "$(dirname "$0")/ssh.func"

# shellcheck source=./container.func
source "$(dirname "$0")/container.func"

# shellcheck source=./system.func
source "$(dirname "$0")/system.func"

# shellcheck source=./dotfiles.func
source "$(dirname "$0")/dotfiles.func"

# shellcheck source=./summary.func
source "$(dirname "$0")/summary.func"

################################################################################
# 3 – Hauptablauf / Main workflow
################################################################################

main() {
    parse_args "$@"
    check_root
    check_bash_version
    check_required_tools
    check_directory_exists "$TEMPLATE_PATH"
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

    # Dry-Run? Dann Vorschau anzeigen und beenden
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
