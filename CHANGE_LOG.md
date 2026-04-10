## [v0.5.3.0-release] - 04/10/2026

### Fixed

- **Tooltip overflow with StatWeightsClassic (issue #17):** CritMatic's crit/hit lines no longer render outside the spell tooltip frame when used alongside other tooltip addons. `Show()` is now called exactly once per render, and only when CritMatic actually added lines.
- **Silent data loss for large crits:** raised `MAX_HIT` ceiling from 40000 to 1e9 so Wrath/Retail endgame crits are recorded instead of silently dropped.
- **Operator-precedence bug in combat log handler:** player-sourced events were bypassing the `destGUID`, `eventType`, and `amount > 0` filters due to missing parentheses around the `or` clause.
- **Nil crashes in combat log handler:** added guards for `baseSpellName`, `destGUID`, and `amount` to prevent errors on unusual event shapes.
- **`RANGE_DAMAGE` events** are now properly tracked (were in the outer filter but had no extraction branch).
- **Reset buttons in options panels** no longer pollute the shared defaults table by reference. All `Reset*ToDefault` functions now use `CopyTable` against `Critmatic.db.defaults`.

### Changed

- Optimized ignored-spells/targets filtering from O(N) per combat event to O(1) hash lookups.
- Added compatibility shims for `C_Spell.GetSpellCooldown` and `GetSpellBookItemInfo` (Retail 11.x).
- Unregistered `PLAYER_LOGIN` and `GROUP_JOINED` events (registered but never handled).

### Removed

- Dead function `IsSpellInSpellbook` (zero callers).
- Dead DB field `dataCleared`.

---

## [v0.5.2.1-release] - 04/09/2026

### Fixed

- Split Wrath Classic (30403) and Titan Reforged (38000) into separate TOC interface directives so the BigWigs packager can build both flavors

---

## [v0.5.2.0-release] - 04/09/2026

### Added

- X/Y percentage sliders for alert text position (configurable in Alert settings, with Reset and Test buttons)

---

## [v0.5.1.0-release] - 01/17/2026

### Fixed
- update interface versions to current (Classic Era 11508, Wrath 38000)

---

## [v0.5.0.0-release] - 01/16/2026

### Added

- missing localization line

### Fixed

- TBC fix's
- invalid Interface-Wrath version (38000 -> 30403)

### Changed

- Wrath titan version to 38000

---

## [v0.4.3.0-release] - 01/14/2026

### Updated:

- **Updated the in-game changelog popup to show recent release notes.**

---

## [v0.4.2.9-release] - 01/12/2026

### Fixed:

- **Fixed tooltip conflict with StatWeightsClassic** - Removed redundant tooltip Show() call that caused CritMatic tooltip info to disappear when used alongside StatWeightsClassic addon.

- **Fixed WoW 11.0 compatibility** - Removed deprecated InterfaceOptionsList_DisplayPanel hook that was causing errors in modern WoW clients.

---

## [v0.4.2.8-release] - 12/25/2023


## [v0.4.2.7.5-release] - 12/25/2023

## [v0.4.2.7.4-release] - 12/16/2023

## [v0.4.2.7.1-release] - 12/10/2023

## [v0.4.2.7-release] - 12/6/2023

### Added:

- **Added options for maxMessages, startDelay, and fadeTime settings also a way to reset them.**

## [v0.4.2.5-release] - 12/6/2023

### Added:

- **Added alert notification preview feature in options under Alert**

- **Chat customization is coming next.**
