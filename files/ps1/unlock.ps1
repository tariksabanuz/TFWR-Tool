param(
    [Parameter(Mandatory=$true)]
    [string]$JsonPath
)

$allUnlocks = @(
    "grass_10","soil","harvest","pass","do_a_flip","pet_the_piggy","grassland","hay","straw_hat","tap",
    "while","true","false","break","continue","loops","speed_5","can_harvest","if","else","elif",
    "change_hat","gray_hat","purple_hat","green_hat","brown_hat","hats","expand_9","move","north","south",
    "east","west","for","range","get_world_size","wood","bush","entities","clear","plant","carrots_10",
    "carrot","till","can_trade","trade","items","carrot_seed","print","quick_print","unlocks","str","debug",
    "and","or","not","operators","get_entity_type","get_ground_type","grounds","get_pos_x","get_pos_y",
    "none","num_items","num_unlocked","senses","variables","append","remove","pop","insert","len","list",
    "lists","functions","def","return","global","dicts","sets","add","dict","set","dictionaries","from",
    "import","min","max","abs","random","utilities","get_cost","costs","unlock","auto_unlock","get_time",
    "get_tick_count","timing","trees_10","tree","watering_9","water","use_item","get_water","sunflower_seed",
    "sunflower","power","get_active_power","measure","sunflowers","weird_substance","fertilizer_4",
    "pumpkins_10","pumpkin","pumpkin_seed","dead_pumpkin","polyculture_5","get_companion","cactus_6","swap",
    "cactus_seed","dinosaurs_6","dinosaur","egg","bone","dinosaur_hat","apple","can_move",
    "the_farmers_remains","mazes_6","hedge","treasure","gold","top_hat","megafarm_5","get_drone_id",
    "num_drones","max_drones","wait_for","spawn_drone","has_finished","simulation","simulate","debug_2",
    "set_execution_speed","set_world_size","leaderboard","leaderboard_run","leaderboards"
)

# Default save data, used if the save is empty
$template = @'
{"items":{"serializeList":[{"name":"hay","nr":998999999999.0},{"name":"wood","nr":999999999989824900000.0},{"name":"carrot","nr":9999998912635954.0},{"name":"pumpkin","nr":9999964214999.0},{"name":"cactus","nr":999999998962585900.0},{"name":"bone","nr":99999896439999.0},{"name":"weird_substance","nr":100000000000000000000.0},{"name":"gold","nr":9.9999999999999e21},{"name":"water","nr":13408.0},{"name":"fertilizer","nr":398.0}]},"dockedFiles":[],"minimizedFiles":[],"openFilePositions":[],"openFileScrollPositions":[],"openFileSizes":[],"openDocPages":[],"unlocks":["grass_10","soil","harvest","pass","do_a_flip","pet_the_piggy","grassland","hay","straw_hat","tap","while","true","false","break","continue","loops","speed_5","can_harvest","if","else","elif","change_hat","gray_hat","purple_hat","green_hat","brown_hat","hats","expand_9","move","north","south","east","west","for","range","get_world_size","wood","bush","entities","clear","plant","carrots_10","carrot","till","can_trade","trade","items","carrot_seed","print","quick_print","unlocks","str","debug","and","or","not","operators","get_entity_type","get_ground_type","grounds","get_pos_x","get_pos_y","none","num_items","num_unlocked","senses","variables","append","remove","pop","insert","len","list","lists","functions","def","return","global","dicts","sets","add","dict","set","dictionaries","from","import","min","max","abs","random","utilities","get_cost","costs","unlock","auto_unlock","get_time","get_tick_count","timing","trees_10","tree","watering_9","water","use_item","get_water","sunflower_seed","sunflower","power","get_active_power","measure","sunflowers","weird_substance","fertilizer_4","pumpkins_10","pumpkin","pumpkin_seed","dead_pumpkin","polyculture_5","get_companion","cactus_6","swap","cactus_seed","dinosaurs_6","dinosaur","egg","bone","dinosaur_hat","apple","can_move","the_farmers_remains","mazes_6","hedge","treasure","gold","top_hat","megafarm_5","get_drone_id","num_drones","max_drones","wait_for","spawn_drone","has_finished","simulate","simulation","set_execution_speed","set_world_size","debug_2","leaderboard_run","leaderboards","leaderboard"],"version":3}
'@

# Recursively search for a property with "unlock" in the name
function Find-UnlockProp($obj, $path) {
    foreach ($p in $obj.PSObject.Properties) {
        if ($p.Name -like "*unlock*") {
            return @{ Parent = $obj; Name = $p.Name; Path = "$path.$($p.Name)" }
        }
    }
    foreach ($p in $obj.PSObject.Properties) {
        if ($p.Value -is [System.Management.Automation.PSCustomObject]) {
            $r = Find-UnlockProp $p.Value "$path.$($p.Name)"
            if ($r) { return $r }
        }
    }
    return $null
}

function Set-UnlockList($container, $prop, $current) {
    # List of strings (or empty) -> just replace
    $isPlain = ($null -eq $current) -or (@($current).Count -eq 0) -or (@($current)[0] -is [string])
    if ($isPlain) {
        $container.$prop = @($allUnlocks)
        return
    }
    # List of objects with name/nr (same format as items.serializeList)
    $existing = @{}
    foreach ($e in @($current)) { $existing[$e.name] = $true }
    $new = @($current)
    foreach ($u in $allUnlocks) {
        if (-not $existing.ContainsKey($u)) {
            $new += [PSCustomObject]@{ name = $u; nr = 1 }
        }
    }
    $container.$prop = $new
}

function Write-Json($text) {
    # Write without BOM (safer for Unity)
    [System.IO.File]::WriteAllText($JsonPath, $text, (New-Object System.Text.UTF8Encoding($false)))
}

if (-not (Test-Path $JsonPath)) {
    Write-Host "Could not find save file: $JsonPath"
    exit 1
}

$raw = Get-Content -Raw -Path $JsonPath
$json = $null
if (-not [string]::IsNullOrWhiteSpace($raw)) {
    try { $json = $raw | ConvertFrom-Json }
    catch {
        Write-Host "The save file is not valid JSON. Nothing was modified."
        Write-Host "File: $JsonPath"
        exit 1
    }
}

$hasContent = ($null -ne $json) -and (@($json.PSObject.Properties).Count -gt 0)
$found = $null
if ($hasContent) {
    $found = Find-UnlockProp $json "json"
    if ($found) { Write-Host "Found: $($found.Path)" }
    else        { Write-Host "No 'unlocks' field in the save, will be added." }
}
else {
    Write-Host "The save is empty, default save data will be added."
}

$confirm = Read-Host "Are you sure you want to unlock EVERYTHING in this save? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Cancelled."
    exit 0
}

# Create backup before overwriting
Copy-Item -Path $JsonPath -Destination "$JsonPath.bak" -Force

if (-not $hasContent) {
    # Empty save -> write entire default JSON
    Write-Json $template.Trim()
}
else {
    if ($found) {
        $parent = $found.Parent
        $name   = $found.Name
        $value  = $parent.$name

        if ($value -is [System.Management.Automation.PSCustomObject] -and ($value.PSObject.Properties.Name -contains "serializeList")) {
            Set-UnlockList $value "serializeList" $value.serializeList
        }
        elseif ($value -is [System.Management.Automation.PSCustomObject]) {
            # Object with property per unlock
            foreach ($u in $allUnlocks) {
                if ($value.PSObject.Properties.Name -contains $u) { $value.$u = 1 }
                else { $value | Add-Member -NotePropertyName $u -NotePropertyValue 1 -Force }
            }
        }
        else {
            Set-UnlockList $parent $name $value
        }
    }
    else {
        # Save has data but no unlocks yet -> add field
        $json | Add-Member -NotePropertyName "unlocks" -NotePropertyValue @($allUnlocks) -Force
    }

    Write-Json ($json | ConvertTo-Json -Depth 100)
}

# Add __builtins__.py to the save folder
$builtinsSrc = Join-Path (Split-Path -Parent $PSScriptRoot) "py+json\__builtins__.py"
$saveDir = Split-Path -Parent $JsonPath
if (Test-Path $builtinsSrc) {
    Copy-Item -Path $builtinsSrc -Destination (Join-Path $saveDir "__builtins__.py") -Force
    Write-Host "__builtins__.py has been added to the save folder."
} else {
    Write-Host "Warning: __builtins__.py not found at $builtinsSrc, not copied."
}

Write-Host ""
Write-Host "Done! Everything is unlocked in this save."
Write-Host "(A backup of the original file has been saved as '$JsonPath.bak')"
