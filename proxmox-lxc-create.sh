#!/usr/bin/env bash
###############################################################################
# proxmox-lxc-create.sh
# -----------------------------------------------------------
# Dieses Skript sammelt alle *.sh und *.func-Dateien im aktuellen Projekt-
# verzeichnis (rekursiv) und schreibt sie in eine Sammeldatei. Die Verzeichnisse
# .git und .vscode werden ignoriert.
#
# This script collects all *.sh and *.func files in the current project directory
# (recursively) and writes them into a single bundle file. The directories .git
# and .vscode are excluded.
#
# Autor/Author: Dein Name
# Datum/Date: 2025-07-20
###############################################################################

OUTPUT="proxmox-lxc-create.txt"

# Leere Ausgabedatei erzeugen / Create empty output file
: > "$OUTPUT"

# Alle relevanten Dateien suchen (rekursiv), .git und .vscode ausschließen
# Find all relevant files recursively, exclude .git and .vscode
find . \
  \( -path '*/.git/*' -o -path '*/.vscode/*' \) -prune -o \
  -type f \( -name '*.sh' -o -name '*.func' \) -print | sort | while read -r f; do
    rel_path="${f#./}"
    # Header für jede Datei / Header for each file
    echo "### $rel_path" >> "$OUTPUT"
    echo >> "$OUTPUT"
    # Dateiinhalt anhängen / Append file content
    cat "$f" >> "$OUTPUT"
    # Zwei Leerzeilen trennen die Dateien / Two blank lines separate files
    echo >> "$OUTPUT"
    echo >> "$OUTPUT"
done

echo "Fertig! Sammeldatei: $OUTPUT"
echo "Done! Bundle file: $OUTPUT"
