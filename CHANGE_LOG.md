## [v5.5.7-release] - 04/22/2026

### Fixed

- **CritMatic icon rendering behind the Crit Log window:** the three icon textures (black circle, CritMatic icon, gold ring) had `SetParent(UIParent)` calls — a workaround from the old `BACKGROUND`-strata days that lifted the textures above the window. With the window now at `MEDIUM` strata, those reparented textures ended up at UIParent's lower frame level and got covered by the window. Removed the reparenting so the textures inherit `critmatic_icon_frame`'s strata/level (child of the main frame) and render above it normally.

---

## [v5.5.6-release] - 04/22/2026

### Fixed

- **Right-click menu rendered behind the Crit Log window (retail 11.0):** v5.5.5 left the widget at `FULLSCREEN_DIALOG` strata (set by the AceGUI constructor), but `MenuUtil.CreateContextMenu` creates menus at `DIALOG`, so the menu was stacking underneath the window. Lowered the widget to `MEDIUM` strata (standard addon default) so context menus, tooltips, and popups render above it.
- **Inner scroll area not following the outer frame on resize:** the ScrollFrame was hardcoded to `SetSize(250, 120)` and anchored only TOPLEFT, so resizing the window left the spell list stuck at a fixed size. The scroll container is now anchored to both TOPLEFT and BOTTOMRIGHT (with room for the sizer and scrollbar), and the scroll child width tracks the container via `OnSizeChanged`. Spell rows now anchor TOPLEFT + TOPRIGHT, so they span the full available width at any frame size.

---

## [v5.5.5-release] - 04/22/2026

### Fixed

- **Crit Log window not movable/resizable on retail 11.0 (#22 follow-up):** the frame was forced to the `BACKGROUND` strata and then `:Lower()`-ed at the end of setup, which put it behind Blizzard's default UI. Overlapping default frames intercepted mouse input, so `RegisterForDrag` and the corner/edge sizers never received clicks. Removed the override; the widget now stays at the strata the Constructor set and drag + resize work again.

---

## [v5.5.4-release] - 04/17/2026

### Fixed

- **Retail 11.0 context menus and hover (#22):** right-click context menus on spell rows and the CritMatic icon no longer error with `EasyMenu (a nil value)`; they now use `MenuUtil.CreateContextMenu` on retail with an `EasyMenu` fallback for Classic/TBC/Wrath. Spell-row hover highlight no longer errors with `SetBackdrop (a nil value)` — the row frame now uses `BackdropTemplate`.
- **Open Settings menu item:** switched to `Settings.OpenToCategory` with an `InterfaceOptionsFrame_OpenToCategory` fallback so the menu entry works on retail 11.0+.

---

## [v5.5.3-release] - 04/13/2026

### Fixed

- **frFR typo:** corrected `valeures` → `valeurs` in the Change Log font reset description (confirmed by @Surfingnet on #21).

---

## [v5.5.2-release] - 04/13/2026

### Added

- **French (frFR) localization** contributed by @Surfingnet (#21) — full translation of all 134 strings, including the v5.5.0 additions (ignored spells panel, right-click context menus).

---

## [v5.5.1-release] - 04/13/2026

### Fixed

- **Login crash on Crit Log creation (#20):** removed stray `RegisterForClicks` calls on non-Button frames introduced in v5.5.0. Right-click context menus on spell rows and the CritMatic icon continue to work via `OnMouseUp` as before.

---

## [v5.5.0-release] - 04/12/2026

### Added

- **Spell icons in alert notifications:** the "New Crit!" popup now shows the spell icon with a matching bounce animation.
- **Resizable Crit Log:** drag the corner/edge to resize the Crit Log widget.
- **Right-click context menus:** right-click any spell in the Crit Log to Ignore it or Delete its data. Right-click the CritMatic icon for quick access to Settings, Lock/Unlock, Reset Position, and Hide.
- **Ignored Spells settings panel:** manage ignored spells from `/cm` options instead of slash commands — select from a dropdown, remove individual spells, or clear all.
- **Hover highlights:** spell entries in the Crit Log highlight on mouseover.

### Improved

- **Tooltip performance:** per-spell max values are now cached instead of rescanning all data on every tooltip hover.
- **Spell icon accuracy:** icons are stored at record time, fixing wrong-icon display for spells with shared names across ranks.

---

## [v5.4.1-release] - 04/12/2026

### Added

- **Crit Log toggle in options panel:** You can now show/hide the live Crit Log widget from `/cm` General Settings instead of needing the `/cmcritlog` slash command.

---

## [v5.4.0-release] - 04/12/2026

### Changed

- **License changed to All Rights Reserved.** CritMatic is now proprietary software. No part of this addon may be copied, modified, or redistributed without express written permission from the copyright holder.
- Updated README with current feature list, macro tooltip support, and license notice.

---

## [v0.5.3.2-release] - 04/11/2026

### Fixed

- **Macro tooltips (issue #19):** CritMatic's crit/hit lines now appear on action-bar macros that cast a tracked spell. The tooltip hook previously bailed out whenever `GetActionInfo` returned `"macro"` instead of `"spell"`; it now resolves the macro to its current spell via `GetMacroSpell(slot)` and proceeds normally. Cast-sequence and conditional macros (`/cast [mod:shift] X; Y`) reflect whichever spell would fire next. Thanks @Alessandro-Barbieri.

---

## [v0.5.3.1-release] - 04/10/2026

### Fixed

- Interface directive now uses comma-separated multi-version format (`110207, 38000, 20505, 11508`) so the BigWigs packager correctly tags the CurseForge release with all four game flavors (Retail, Titan Reforged, TBC, Classic Era). The v0.5.3.0 upload was only tagged as 11.2.7 because the space-separated form tripped the packager's parser.

---

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
- Raw-source installs now load cleanly on Classic Era, TBC, and Wrath/Titan clients without the "out of date" warning (main `## Interface:` directive now lists 110207 38000 20505 11508). Thanks @Alessandro-Barbieri (#18).

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
