# The Below Section Randomly Selects the Player Character's Class

function Get-PlayerCharacter {
    $ClassMap = @{
        1  = "Fighter";           2  = "Kensai";              3  = "Berserker"
        4  = "Wizard Slayer";     5  = "Dwarven Defender";    6  = "Barbarian"
        7  = "Ranger";            8  = "Archer";               9  = "Stalker"
        10 = "Beast Master";      11 = "Paladin";              12 = "Cavalier"
        13 = "Undead Hunter";     14 = "Inquisitor";           15 = "Blackguard"
        16 = "Cleric";            17 = "Priest of Lathander";  18 = "Priest of Helm"
        19 = "Priest of Talos";   20 = "Priest of Tyr";        21 = "Druid"
        22 = "Totemic Druid";     23 = "Avenger";              24 = "Shapeshifter"
        25 = "Shaman";            26 = "Mage"
        27 = "Thief";             28 = "Assassin";             29 = "Bounty Hunter"
        30 = "Swashbuckler";      31 = "Shadowdancer"
        32 = "Bard";              33 = "Blade";                34 = "Jester"
        35 = "Skald";             36 = "Monk";                 37 = "Sun Soul Monk"
        38 = "Dark Moon Monk";    39 = "Fighter/Thief";        40 = "Fighter/Cleric"
        41 = "Fighter/Mage";      42 = "Mage/Thief";           43 = "Cleric/Mage"
        44 = "Cleric/Thief";      45 = "Fighter/Druid";        46 = "Cleric/Ranger"
        47 = "Fighter/Mage/Thief";48 = "Fighter/Mage/Cleric"
    }

    $PlayerChar = Get-Random -Minimum 1 -Maximum ($ClassMap.Count + 1)
    $PCClass = $ClassMap[$PlayerChar]

    # If generalist Mage is rolled (multiclasses containing Mage stay generalist), drill into a specific kit
    if ($PCClass -eq "Mage") {
        $PCClass = Get-MageKit
    }

    Write-Host -ForegroundColor Yellow "Selected PC Class is:"
    Write-Host -ForegroundColor Red "$PCClass"

    return $PCClass
}

function Get-MageKit {
    $MageMap = @{
        1  = "Mage"          # generalist
        2  = "Abjurer"
        3  = "Conjurer"
        4  = "Diviner"
        5  = "Enchanter"
        6  = "Illusionist"
        7  = "Invoker"
        8  = "Necromancer"
        9  = "Transmuter"
        10 = "Wild Mage"
        11 = "Sorcerer"
        12 = "Dragon Disciple"
    }

    $Roll = Get-Random -Minimum 1 -Maximum ($MageMap.Count + 1)
    return $MageMap[$Roll]
}

function Get-Alignment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PCClass
    )

    $LG = "Lawful Good"; $NG = "Neutral Good"; $CG = "Chaotic Good"
    $LN = "Lawful Neutral"; $TN = "True Neutral"; $CN = "Chaotic Neutral"
    $LE = "Lawful Evil"; $NE = "Neutral Evil"; $CE = "Chaotic Evil"

    $All        = @($LG,$NG,$CG,$LN,$TN,$CN,$LE,$NE,$CE)
    $Good       = @($LG,$NG,$CG)
    $Evil       = @($LE,$NE,$CE)
    $NonLawful  = @($NG,$CG,$TN,$CN,$NE,$CE)
    $Lawful     = @($LG,$LN,$LE)
    $Neutral    = @($LN,$TN,$CN)

    # Alignment restrictions per 2E AD&D / BGEE rules
    $AlignmentMap = @{
        "Fighter" = $All; "Kensai" = $All; "Wizard Slayer" = $All
        "Dwarven Defender" = $All
        "Berserker" = $NonLawful; "Barbarian" = $NonLawful

        "Ranger" = $Good; "Archer" = $Good; "Beast Master" = $Good
        "Stalker" = $All

        "Paladin" = @($LG); "Cavalier" = @($LG); "Inquisitor" = @($LG)
        "Undead Hunter" = $Good
        "Blackguard" = $Evil

        "Cleric" = $All
        "Priest of Lathander" = $Good
        "Priest of Helm" = $Lawful
        "Priest of Talos" = @($CE, $CN, $NE)
        "Priest of Tyr" = @($LG)

        "Druid" = $Neutral; "Totemic Druid" = $Neutral; "Avenger" = $Neutral
        "Shapeshifter" = $Neutral; "Shaman" = $Neutral

        "Mage" = $All; "Abjurer" = $All; "Conjurer" = $All; "Diviner" = $All
        "Enchanter" = $All; "Illusionist" = $All; "Invoker" = $All
        "Necromancer" = $All; "Transmuter" = $All; "Wild Mage" = $All
        "Sorcerer" = $All; "Dragon Disciple" = $All

        "Thief" = $All; "Bounty Hunter" = $All; "Swashbuckler" = $All
        "Shadowdancer" = $All
        "Assassin" = $Evil

        "Bard" = $NonLawful; "Blade" = $NonLawful; "Jester" = $NonLawful
        "Skald" = $NonLawful

        "Monk" = $Lawful
        "Sun Soul Monk" = $Good
        "Dark Moon Monk" = $Evil

        "Fighter/Thief" = $All; "Fighter/Cleric" = $All; "Fighter/Mage" = $All
        "Mage/Thief" = $All; "Cleric/Mage" = $All; "Cleric/Thief" = $All
        "Fighter/Mage/Thief" = $All; "Fighter/Mage/Cleric" = $All

        "Fighter/Druid" = $Neutral
        "Cleric/Ranger" = $Good
    }

    $AllowedAlignments = $AlignmentMap[$PCClass]
    $SelectedAlignment = $AllowedAlignments | Get-Random -Count 1

    Write-Host -ForegroundColor Yellow "Selected Alignment:"
    Write-Host -ForegroundColor Red "$SelectedAlignment"

    return $SelectedAlignment
}

function Get-PartyMembers {
    $Duos = @(
        ,@("Xzar", "Montaron")
        ,@("Khalid", "Jaheira")
        ,@("Eldoth", "Skie")
        ,@("Minsc", "Dynaheir")
    )

    $AllMembers = "Ajantis","Alora","Branwen","Dorn Il-Khan","Dynaheir","Edwin","Eldoth","Faldorn","Garrick","Imoen","Jaheira","Kagain","Khalid","Kivan","Minsc","Montaron","Neera","Quayle","Rasaad","Safana","Shar-Teel","Skie","Tiax","Viconia","Xan","Xzar","Yeslick","Baeloth"

    $DuoMembers = $Duos | ForEach-Object { $_ }
    $Singles = $AllMembers | Where-Object { $DuoMembers -notcontains $_ }

    # Build a unit pool: duos stay bundled as 2-member units, everyone else is a 1-member unit
    $Units = @()
    $Units += $Duos
    foreach ($s in $Singles) { $Units += ,@($s) }

    # Shuffle by INDEX, not by piping the units themselves — piping arrays of arrays
    # through Get-Random unrolls each sub-array into individual elements, which is
    # what broke the duo grouping (Eldoth/Skie got split apart)
    $ShuffledIndices = 0..($Units.Count - 1) | Get-Random -Count $Units.Count

    $SelectedPartyMembers = @()
    foreach ($idx in $ShuffledIndices) {
        $unit = $Units[$idx]
        if (($SelectedPartyMembers.Count + $unit.Count) -le 5) {
            $SelectedPartyMembers += $unit
        }
        if ($SelectedPartyMembers.Count -ge 5) { break }
    }

    Write-Host -ForegroundColor Yellow "Selected Party Members:"
    Write-Host -ForegroundColor Red "$SelectedPartyMembers"
}

# Player Character Selection Execution Below

Write-Host -ForegroundColor Cyan "Selecting Player Character Class"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "3"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "2"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "1"
Start-Sleep -Seconds 1

$SelectedClass = Get-PlayerCharacter

Start-Sleep -Seconds 3

# Player Alignment Chosen Below

Write-Host -ForegroundColor Cyan "Selecting Alignment"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "3"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "2"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "1"
Start-Sleep -Seconds 1

Get-Alignment -PCClass $SelectedClass

# Party Member Selections Below While Avoiding Duplicates

Write-Host -ForegroundColor Cyan "Selecting Party Members"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "3"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "2"
Start-Sleep -Seconds 1
Write-Host -ForegroundColor DarkGreen "1"
Start-Sleep -Seconds 1

Get-PartyMembers
