# Infinity Engine Randomizers

A small static **web app** that rolls a random build for a fresh Infinity Engine
challenge run — class/kit, alignment, and party composition. Point it at a game
and it hands you a complete "play it this way" character and party.

Currently supports **Baldur's Gate 1 (Enhanced Edition)**. The randomizer began
life as a PowerShell script (still preserved under
[`legacy_powershell_scripts/`](legacy_powershell_scripts/)) and has since been
rebuilt as a browser-based app built with [Hugo](https://gohugo.io/).

## How it works

There's no backend. The game's rules live in a JSON data file; **Hugo** reads
that file at build time and bakes it into the page, and the actual rolling
happens **entirely in your browser** in plain JavaScript. That means the site is
fully static — it can be hosted anywhere and works offline once loaded.

- **Build time (Hugo):** `data/bg1.json` (classes, kits, alignment rules, party
  NPCs) is injected into the page as an inline `application/json` payload.
- **Run time (browser):** clicking **Roll a Run** parses that data and performs
  three rolls — class, alignment, and party — then reveals the results.

```mermaid
flowchart TD
    subgraph build["Build time — Hugo"]
        data[("data/bg1.json<br/>classes · kits · alignment rules<br/>party NPCs · duos · exclusions")]
        tmpl["layouts/index.html<br/>injects data as application/json"]
        data --> tmpl
        tmpl --> page["Static page<br/>(HTML + CSS + randomizer.js)"]
    end

    subgraph run["Run time — browser"]
        click(["User clicks<br/>“Roll a Run”"]) --> parse["Parse injected JSON"]

        parse --> rollClass["Roll class<br/>from full kit list"]
        rollClass --> mageCheck{"Rolled a<br/>generalist Mage?"}
        mageCheck -- yes --> mageKit["Drill into a<br/>specific mage kit"]
        mageCheck -- no --> rollAlign["Roll alignment<br/>allowed for that class"]
        mageKit --> rollAlign

        rollAlign --> rollParty["Roll party<br/>(shuffle units, fill to 5)"]
        rollParty --> duos["Keep bonded duos together"]
        duos --> excl["Skip units that break<br/>an exclusion (e.g. Edwin ✗ Dynaheir)"]
        excl --> reveal["Reveal class · alignment · party"]
    end

    page -.served to.-> click
```

## The rolls

- **Player class** — picks from the full BGEE / 2E kit list: all base classes,
  kits, and dual/multiclass combos. If a generalist Mage is rolled, it drills
  down into a specific mage kit (Abjurer, Sorcerer, Wild Mage, etc.).
- **Alignment** — rolls an alignment consistent with 2E AD&D / BGEE class
  restrictions (e.g. Paladins are always Lawful Good, Druids stay Neutral).
- **Party members** — fills the party up to 5 recruitable NPCs. Two rules keep
  the result playable in-game:
  - **Bonded duos** (Xzar & Montaron, Khalid & Jaheira, Eldoth & Skie,
    Minsc & Dynaheir) are kept together — you get both or neither.
  - **Exclusions** — NPCs who refuse to travel together are never both picked
    (Edwin and Dynaheir, since Edwin's quest is to kill her).

## Running locally

Requires the [Hugo](https://gohugo.io/) static site generator (extended).

```bash
hugo server        # live-reloading dev server at http://localhost:1313
```

To produce a static build in `public/`:

```bash
hugo --gc --minify
```

## Project layout

```
├── hugo.toml                 # Hugo site config
├── content/_index.md         # homepage stub
├── layouts/                  # page shell + roller markup, injects the ruleset
├── assets/
│   ├── css/main.css          # theme
│   └── js/randomizer.js      # rollClass / rollAlignment / rollParty
├── data/
│   └── bg1.json              # the BG1 ruleset (single source of truth)
└── legacy_powershell_scripts/
    └── bg1_randomizer.ps1     # original console version
```

Adding another game is mostly a data exercise: drop in a new `data/<game>.json`
following the same shape, and reuse the roller logic.

## Legacy PowerShell script

The original console randomizer lives in
[`legacy_powershell_scripts/bg1_randomizer.ps1`](legacy_powershell_scripts/bg1_randomizer.ps1).
It prints each roll to the console and requires PowerShell (Windows PowerShell or
PowerShell Core / `pwsh`):

```powershell
./legacy_powershell_scripts/bg1_randomizer.ps1
```

## Roadmap

Additional randomizers for **Baldur's Gate 2** and **Icewind Dale** are planned,
each as its own game data file feeding the same roller.
