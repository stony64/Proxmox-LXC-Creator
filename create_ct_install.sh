#!/usr/bin/env bash
set +x
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

################################################################################
# 1 – Globale Einstellungen / Global configuration
################################################################################

readonly STORAGE="FP1000GB"
readonly TEMPLATE_PATH="/mnt/FP1000GB/template/cache"

# shellcheck disable=SC2034
readonly LOGFILE="/root/repos/proxmox-lxc-creator/lxc_create_$(date +'%Y%m%d_%H%M%S').log"

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

# shellcheck source=./logging.func
source "$(dirname "$0")/logging.func"
trap 'log_error "FEHLER in Zeile $LINENO / ERROR at line $LINENO"; exit 2' ERR

# shellcheck source=./translation.func
set +u
source "$(dirname "$0")/translation.func"
load_translations
echo "LOGFILE = '${LOGFILE:-NICHT GESETZT}'"
log "Sprache geladen: $LANGCODE"
log "MSG[mode_title]: '${MSG[mode_title]}'"

for func in security dialogs cli input network ssh container system dotfiles summary; do
    # shellcheck source=./$func.func
    source "$(dirname "$0")/$func.func"
done

set -u

################################################################################
# 3 – Hauptablauf / Main workflow
################################################################################

main() {
    log "PARAM_DRYRUN ist: ${PARAM_DRYRUN:-nicht gesetzt}"
    parse_args "$@"
    log "Parse args abgeschlossen"
    check_root
    log "check root abgeschlossen"
    check_bash_version
    log "BASH_VERSINFO: ${BASH_VERSINFO[@]:-(leer)}"
    log "check_bash_version abgeschlossen"
    check_required_tools
    log "check_required_tools abgeschlossen"
    check_directory_exists "$TEMPLATE_PATH"
    log "check_directory_exists abgeschlossen: $TEMPLATE_PATH"
    select_mode
    log "select_mode abgeschlossen"
    find_next_ctid
    log "find_next_ctid abgeschlossen: CT_ID=$CT_ID"
    input_hostname
    log "input_hostname abgeschlossen: CT_HOSTNAME=$CT_HOSTNAME"
    input_password
    log "input_password abgeschlossen: CT_PASSWORD=******"
    select_template
    log "select_template abgeschlossen: TEMPLATE_FILE=$TEMPLATE_FILE"
    detect_ostype_from_template
    log "detect_ostype_from_template abgeschlossen: OSTEMPLATE=$OSTEMPLATE, OSType=$OSType"
    input_rootfs_size
    log "input_rootfs_size abgeschlossen: ROOTFS_SIZE=$ROOTFS_SIZE"
    input_resources
    log "input_resources abgeschlossen: CT_CORES=$CT_CORES, CT_MEMORY=$CT_MEMORY"
    get_container_ip
    log "get_container_ip abgeschlossen: CT_IPV4=$CT_IPV4, CT_IPV6=$CT_IPV6"
    ask_for_laptop_key_comment
    log "ask_for_laptop_key_comment abgeschlossen: LAPTOP_KEY_COMMENT=$LAPTOP_KEY_COMMENT"
    extract_laptop_key
    log "extract_laptop_key abgeschlossen: SSH_PUBKEY=${SSH_PUBKEY:-nicht gesetzt}"

    # Dry-Run? Dann Vorschau anzeigen und beenden
    #[[ "${1:-}" == "--dry-run" ]] && { dry_run_preview; exit 0; }
    if [[ "${PARAM_DRYRUN:-false}" == "true" ]]; then
        dry_run_preview
        exit 0
    fi
    log "Dry-Run abgeschlossen"

    prepare_ssh_key_prestart
    log "prepare_ssh_key_prestart abgeschlossen: SSH_PUBKEY=${SSH_PUBKEY:-nicht gesetzt}"
    create_container
    log "Container mit ID $CT_ID erstellt."
    finalize_ssh_key_after_start
    log "finalize_ssh_key_after_start abgeschlossen: SSH_PUBKEY=${SSH_PUBKEY:-nicht gesetzt}"
    configure_locales
    log "configure_locales abgeschlossen"
    update_container
    log "update_container abgeschlossen"
    clone_dotfiles_in_container
    log "clone_dotfiles_in_container abgeschlossen"
    print_summary
    log "print_summary abgeschlossen"
}
main "$@"
set -x
