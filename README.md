# Infinity Engine Randomizers

PowerShell randomizer scripts for Infinity Engine games (Baldur's Gate 1/2, Icewind Dale). Each script rolls a random build for a fresh challenge run: class/kit, alignment, and party composition.

## Scripts

### `bg1_randomizer.ps1`

Randomizes a Baldur's Gate 1 playthrough:

- **Player class** — picks from the full BGEE/2E kit list, including all base classes, kits, and dual/multiclass combos. If a generalist Mage is rolled, it drills down into a specific mage kit (Abjurer, Sorcerer, Wild Mage, etc.).
- **Alignment** — rolls an alignment consistent with 2E AD&D / BGEE class restrictions (e.g. Paladins are always Lawful Good, Druids stay Neutral).
- **Party members** — randomly selects up to 5 recruitable NPCs to fill out the party. Bonded duos (Xzar & Montaron, Khalid & Jaheira, Eldoth & Skie, Minsc & Dynaheir) are kept together as a pair if either is selected.

#### Usage

```powershell
./bg1_randomizer.ps1
```

Requires PowerShell (Windows PowerShell or PowerShell Core / `pwsh`). Output is printed to the console as each category is rolled.

## Roadmap

Additional randomizers for Baldur's Gate 2 and Icewind Dale are planned.
