#!/usr/bin/env bash
# bundle_proj.sh
# Sammelt alle *.sh und *.func-Dateien (rekursiv) – aber OHNE .git und .vscode

OUTPUT="proxmox-lxc-create.txt"
: > "$OUTPUT"   # Leere Ausgabedatei erzeugen

find . \
  \( -path '*/.git/*' -o -path '*/.vscode/*' \) -prune -o \
  -type f \( -name '*.sh' -o -name '*.func' \) -print | sort | while read -r f; do
    rel_path="${f#./}"
    echo "### $rel_path" >> "$OUTPUT"
    echo >> "$OUTPUT"
    cat "$f" >> "$OUTPUT"
    echo >> "$OUTPUT"
    echo >> "$OUTPUT"
done

echo "Fertig! Sammeldatei: $OUTPUT"
