param(
    [Parameter(Mandatory=$true)]
    [string]$JsonPath
)

$resources = @(
    @{ label = "hay";              json = "hay" },
    @{ label = "wood";             json = "wood" },
    @{ label = "carrot";           json = "carrot" },
    @{ label = "pumpkin";          json = "pumpkin" },
    @{ label = "cactus";           json = "cactus" },
    @{ label = "bone";             json = "bone" },
    @{ label = "weird substance";  json = "weird_substance" },
    @{ label = "gold";             json = "gold" },
    @{ label = "water";            json = "water" },
    @{ label = "fertilizer";       json = "fertilizer" }
)

Write-Host ""
for ($i = 0; $i -lt $resources.Count; $i++) {
    Write-Host "$($i+1) | $($resources[$i].label)"
}
Write-Host ""

$choice = Read-Host "Which resource do you want to modify (number)"
$idx = 0
if (-not [int]::TryParse($choice, [ref]$idx) -or $idx -lt 1 -or $idx -gt $resources.Count) {
    Write-Host "Invalid choice."
    exit 1
}
$resLabel = $resources[$idx - 1].label
$resName = $resources[$idx - 1].json

$amountInput = Read-Host "How many $resLabel do you want"
$amount = 0.0
if (-not [double]::TryParse($amountInput, [ref]$amount)) {
    Write-Host "Invalid number."
    exit 1
}

if (-not (Test-Path $JsonPath)) {
    Write-Host "Could not find save file: $JsonPath"
    exit 1
}

$raw = Get-Content -Raw -Path $JsonPath
$json = $raw | ConvertFrom-Json


$list = $null
try { $list = $json.items.serializeList } catch { $list = $null }

if ($null -eq $list) {
    Write-Host "Could not find 'items.serializeList' in the save file."
    exit 1
}

$updated = $false
foreach ($entry in $list) {
    if ($entry.name -eq $resName) {
        $entry.nr = $amount
        $updated = $true
        break
    }
}

if (-not $updated) {
    # Resource not in save yet (never collected) -> add it
    $newEntry = [PSCustomObject]@{ name = $resName; nr = $amount }
    $json.items.serializeList = @($list) + $newEntry
    $updated = $true
    Write-Host "'$resLabel' was not in the save, has been added."
}

# Create backup before overwriting
Copy-Item -Path $JsonPath -Destination "$JsonPath.bak" -Force

$json | ConvertTo-Json -Depth 100 -Compress:$false | Set-Content -Path $JsonPath -Encoding UTF8

Write-Host ""
Write-Host "Done! '$resLabel' is now set to $amount."
Write-Host "(A backup of the original file has been saved as '$JsonPath.bak')"
