# CritMatic — Claude Context

WoW addon that tracks and displays highest crits/normals per spell. Supports Retail, Classic Era, TBC, Wrath, and Titan Reforged.

## Release workflow

Releases go to CurseForge via the BigWigs packager (`.release/release.sh`). The CurseForge API token lives in `.env` as `CF_API_KEY` (private repo, not committed).

**Steps:**

1. Bump `## Version:` in `CritMatic.toc`
2. Bump `critmatic_version` in `versions.json`
3. Prepend a new `## [vX.Y.Z-release] - MM/DD/YYYY` block to `CHANGE_LOG.md` (the packager reads this via `.pkgmeta.yaml` → `manual-changelog`)
4. Commit the version bump
5. Annotated tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
6. Push: `git push origin master vX.Y.Z`
7. Build + upload: `set -a && source .env && set +a && .release/release.sh`
8. Verify `Success!` in the output, then archive: `cp .release/CritMatic-vX.Y.Z.zip Releases/`

Project ID on CurseForge: `903801` (set via `## X-Curse-Project-ID: 903801` in the TOC).

## TOC Interface line — comma-separated, NOT space-separated

The main `## Interface:` directive in `CritMatic.toc` lists multiple versions for raw-install compatibility across flavors. **These values MUST be comma-separated:**

```
## Interface: 110207, 38000, 20505, 11508
```

**NOT** `## Interface: 110207 38000 20505 11508`.

The BigWigs packager (`release.sh` line ~1177) parses this line with `awk -F: '{ gsub(/[ \t]/, "", $2); print $2 }'` — it strips ALL whitespace, then splits on commas. Space-separated values get concatenated into one 21-digit garbage string (e.g. `110207380002050511508`), which fails CurseForge's game-version matching. The upload still succeeds but gets tagged with only one version (usually Retail 11.2.7), so Classic/TBC/Wrath users see the project page as "unsupported".

WoW itself accepts both comma and space-separated forms, so the bug is silent at runtime — only visible in the packager output as `WARNING: No CurseForge game version match for "<long-digit-string>"`.

This was introduced by PR #18 (space-separated, shipped in v0.5.3.0) and fixed in v0.5.3.1 by switching to commas. If you ever need to re-edit the main Interface line, use commas.

## Layout at a glance

- `CritMatic.lua` — main addon: hooks, CLEU handler, slash commands, comms
- `MessageFrame.lua` — alert notification frame
- `Modules/CritLog.lua` — crit log window + AceGUI widget
- `Modules/CritMaticDB.lua` — AceDB defaults (note: `defaults` is a global so `CritMatic.lua:194` can see it at load time — see embeds.xml load order)
- `Modules/CritMaticOptions.lua` + `Modules/optionParts/*` — options UI
- `Localization/enUS.lua` — primary locale (the other locale files are 6-line stubs; AceLocale falls back to enUS)
- `Libs/` — vendored Ace3, LibSharedMedia, LibStub (out of scope for reviews)

## Load order gotcha

`embeds.xml` loads `Modules/CritMaticSharedMedia.lua` and `Modules/CritMaticDB.lua` BEFORE `CritMatic.lua`. So `Critmatic` (the Ace3 addon object) doesn't exist when `CritMaticDB.lua` runs — don't try to attach things to the `Critmatic` namespace from there. `defaults` stays global for this reason, and AceDB-3.0 exposes it as `Critmatic.db.defaults` after `:New()` is called later.

## AceDB defaults reset pattern

Options panel `Reset*ToDefault` functions MUST use `CopyTable(Critmatic.db.defaults.profile.X)` — NOT bare `= defaults.profile.X`. Direct reference assignment mutates the shared defaults table when the user subsequently edits the reset value, polluting new profiles and making future Resets no-ops. See commit `3a4ee8a` and the v0.5.3.0 changelog for the fix.
