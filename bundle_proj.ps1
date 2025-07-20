# bundle_proj.ps1
# Sammelt alle *.sh und *.func-Dateien (rekursiv), exkludiere .git und .vscode

$OutputFile = "proxmox-lxc-create.txt"

# Leere Ausgabedatei erzeugen
Set-Content -Path $OutputFile -Value ""

# Alle relevanten Dateien suchen, dabei .git und .vscode auslassen
$Files = Get-ChildItem -Recurse -Include *.sh,*.func -File |
    Where-Object {
        # Ausschließen, wenn in .git oder .vscode
        -not ($_.FullName -match '\\.git\\' -or $_.FullName -match '\\.vscode\\')
    } |
    Sort-Object FullName

foreach ($File in $Files) {
    # Relativen Pfad ermitteln (mit / statt \ falls gewünscht)
    $RelPath = $File.FullName.Substring($PWD.Path.Length + 1) -replace '\\', '/'
    
    # Überschrift
    Add-Content -Path $OutputFile -Value "### $RelPath"
    Add-Content -Path $OutputFile -Value ""
    
    # Dateiinhalt anhängen
    Get-Content -Path $File.FullName | Add-Content -Path $OutputFile

    # Zwei Leerzeilen trennen die Dateien
    Add-Content -Path $OutputFile -Value ""
    Add-Content -Path $OutputFile -Value ""
}

Write-Host "Fertig! Sammeldatei: $OutputFile"
