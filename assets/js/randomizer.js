// Infinity Engine Randomizer — browser port of bg1_randomizer.ps1
// Data is injected at build time by Hugo into window.RANDOMIZER_DATA.
(function () {
  "use strict";

  const dataEl = document.getElementById("randomizer-data");
  if (!dataEl) {
    console.error("randomizer-data script missing — did the Hugo template inject it?");
    return;
  }
  const DATA = JSON.parse(dataEl.textContent);

  // --- core RNG ------------------------------------------------------------
  function pick(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
  }

  // Fisher–Yates shuffle (returns a new array)
  function shuffle(arr) {
    const a = arr.slice();
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
  }

  // --- rolls (mirror the PowerShell functions) -----------------------------

  // Get-PlayerCharacter + Get-MageKit: a generalist Mage drills into a kit.
  function rollClass() {
    let cls = pick(DATA.classes);
    if (cls === "Mage") cls = pick(DATA.mageKits);
    return cls;
  }

  // Get-Alignment: resolve the class's rule (group name or code array) to
  // full alignment names, then pick one.
  function rollAlignment(cls) {
    const rule = DATA.alignmentRules[cls];
    const codes = Array.isArray(rule) ? rule : DATA.groups[rule];
    const names = codes.map((c) => DATA.alignments[c]);
    return pick(names);
  }

  // Get-PartyMembers: duos stay bundled as 2-member units, everyone else is a
  // 1-member unit. Shuffle the units and greedily fill up to partySize.
  function rollParty() {
    const duoMembers = DATA.duos.flat();
    const singles = DATA.allMembers.filter((m) => !duoMembers.includes(m));

    const units = [...DATA.duos, ...singles.map((s) => [s])];
    const shuffled = shuffle(units);

    const party = [];
    for (const unit of shuffled) {
      if (party.length + unit.length <= DATA.partySize) party.push(...unit);
      if (party.length >= DATA.partySize) break;
    }
    return party;
  }

  // --- UI ------------------------------------------------------------------
  const els = {
    rollBtn: document.getElementById("roll-btn"),
    results: document.getElementById("results"),
    classVal: document.getElementById("class-value"),
    alignVal: document.getElementById("alignment-value"),
    partyVal: document.getElementById("party-value"),
    cards: Array.from(document.querySelectorAll(".result-card")),
  };

  function setCard(card, valueEl, text) {
    card.classList.remove("revealed");
    valueEl.textContent = text;
    // force reflow so the animation restarts on re-roll
    void card.offsetWidth;
    card.classList.add("revealed");
  }

  function renderParty(members) {
    els.partyVal.innerHTML = "";
    members.forEach((name) => {
      const chip = document.createElement("span");
      chip.className = "chip";
      chip.textContent = name;
      els.partyVal.appendChild(chip);
    });
  }

  async function roll() {
    els.rollBtn.disabled = true;
    els.results.classList.add("rolling");

    const cls = rollClass();
    const alignment = rollAlignment(cls);
    const party = rollParty();

    // staggered reveal, echoing the script's 3-2-1 countdown pacing
    const steps = [
      () => setCard(els.cards[0], els.classVal, cls),
      () => setCard(els.cards[1], els.alignVal, alignment),
      () => {
        renderParty(party);
        els.cards[2].classList.remove("revealed");
        void els.cards[2].offsetWidth;
        els.cards[2].classList.add("revealed");
      },
    ];

    for (const step of steps) {
      step();
      await new Promise((r) => setTimeout(r, 550));
    }

    els.results.classList.remove("rolling");
    els.rollBtn.disabled = false;
    els.rollBtn.textContent = "Roll Again";
  }

  els.rollBtn.addEventListener("click", roll);
})();
