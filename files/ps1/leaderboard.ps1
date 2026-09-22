param(
    [Parameter(Mandatory=$true)]
    [string]$SavePath
)

# Zoek Python-executable
$pythonExe = $null

# Check standaard locaties
$pythonPaths = @(
    "python.exe",
    "python3.exe",
    "$env:LOCALAPPDATA\Programs\Python\Python*\python.exe",
    "C:\Python*\python.exe"
)

foreach ($path in $pythonPaths) {
    if (Test-Path $path -ErrorAction SilentlyContinue) {
        $pythonExe = (Get-Item $path | Select-Object -Last 1).FullName
        break
    }
}

# Probeer via where command
if (-not $pythonExe) {
    $pythonExe = (where.exe python.exe 2>$null)
}

if (-not $pythonExe) {
    $pythonExe = (where.exe python3.exe 2>$null)
}

# Als Python niet gevonden, geven we fout
if (-not $pythonExe) {
    Write-Host ""
    Write-Host "[FOUT] Python is niet geinstalleerd of niet in PATH!"
    Write-Host ""
    Write-Host "Installeer Python van https://www.python.org/"
    Write-Host "Zorg ervoor dat 'Add Python to PATH' is aangevinkt!"
    Write-Host ""
    exit 1
}

Write-Host "Python gevonden: $pythonExe"
Write-Host ""

# Python code die we gaan runnen
$pythonCode = @"
import sys
sys.path.insert(0, r'$SavePath')

# Main2.0 - de simulate run
f0 = simulate("Main2.0", {}, {}, {}, 0, 1)

# Main2.0 - wacht tot Leaderboard is unlocked
while num_unlocked(Unlocks.Leaderboard) == 0:
    pass

print("Leaderboard unlocked!")
"@

# Schrijf Python-code naar een temp bestand
$pythonFile = "$env:TEMP\tfwr_leaderboard_temp.py"
$pythonCode | Set-Content -Path $pythonFile -Encoding UTF8

Write-Host "Python-script wordt uitgevoerd..."
Write-Host ""

# Voer Python uit
& $pythonExe $pythonFile

# Cleanup
Remove-Item -Path $pythonFile -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Leaderboard run voltooid!"
