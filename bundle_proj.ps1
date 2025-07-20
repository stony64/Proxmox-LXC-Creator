<#
    bundle_proj.ps1
    ----------------
    Dieses Skript sammelt alle *.sh und *.func-Dateien im aktuellen Projektverzeichnis (rekursiv)
    und schreibt sie in eine Sammeldatei. Die Verzeichnisse .git und .vscode werden ignoriert.

    This script collects all *.sh and *.func files in the current project directory (recursively)
    and writes them into a single bundle file. The directories .git and .vscode are excluded.

    Datum/Date: 2025-07-20
#>

$OutputFile = "proxmox-lxc-create.txt"

# Leere Ausgabedatei erzeugen / Create empty output file
Set-Content -Path $OutputFile -Value "" -Encoding UTF8

# Alle relevanten Dateien suchen (rekursiv), .git und .vscode ausschließen
# Find all relevant files recursively, exclude .git and .vscode
$Files = Get-ChildItem -Path . -Recurse -Include *.sh,*.func -File |
    Where-Object {
        $_.FullName -notmatch '\\.git\\' -and $_.FullName -notmatch '\\.vscode\\'
    } |
    Sort-Object FullName

foreach ($File in $Files) {
    # Relativen Pfad ermitteln (mit / statt \ für bessere Lesbarkeit)
    # Get relative path (replace \ with / for readability)
    $RelPath = $File.FullName.Substring($PWD.Path.Length + 1) -replace '\\', '/'

    # Header für jede Datei / Header for each file
    Add-Content -Path $OutputFile -Value "### $RelPath" -Encoding UTF8
    Add-Content -Path $OutputFile -Value "" -Encoding UTF8

    # Dateiinhalt anhängen / Append file content
    Get-Content -Path $File.FullName -Encoding UTF8 | Add-Content -Path $OutputFile -Encoding UTF8

    # Zwei Leerzeilen trennen die Dateien / Two blank lines separate files
    Add-Content -Path $OutputFile -Value @("", "") -Encoding UTF8
}

Write-Host "Fertig! Sammeldatei: $OutputFile"
Write-Host "Done! Bundle file: $OutputFile"
