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

## [v0.4.2.1-release] - 12/4/2023

### Updated:

- **Removed ignore Auto Attack from options. You can use /cmignore spell name to ignore Auto Attack instead.**

### Added:

- **You can now customize the alert notification message. Use /cm Its under Alert. Soon chat messages too.**

## [v0.4.1-release] - 12/3/2023

### Updated:

- **When you use /cmcritlogdefaultpos it will now show if its currently hidden.**

## [v0.4.0-release] - 12/2/2023

### Fixed:

- **Fixed issue where Crit Log shifts right on Reload/Logout.**

### Added:

- **To reset specific spell data, use the command /cmdeletespelldata spell name This avoids the need to clear all data
  with /cmreset.**

## [v0.3.9.8-release] - 12/1/2023

### Added:

- **Added a new slash command to reset the position of Crit Log if it goes off screen. Use /cmcritlogdefaultpos Causes a
  ReloadUI.**

## [v0.3.9.7-release] - 12/1/2023

## [v0.3.9.6-release] - 12/1/2023

### Fixed:

- **Removed localization for everything but English for now, because it was causing bugs.**

## [v0.3.9.5-release] - 11/30/2023

### Fixed:

- **Resolved issue with /cmcritlog slash command not functioning as expected.**

- **Additional slash commands have been tested and confirmed operational.**

### Updated:

- **You can now ignore specific spells from tracking by using /cmignore Spell Name.**

- **Make sure the spelling is correct, but it's case insensitive. Use /cmhelp for even more slash commands.**

## [v0.3.8.8-release] - 11/29/2023

### Updated:

- **We need your help translating CritMatic to other languages just visit the localization tab
  on https://legacy.curseforge.com/wow/addons/critmatic to start.**

- **You will translation credit in the addon and on Curse-Forge.**

## [v0.3.8.3-release] - 11/26/2023

### Fixed:

- **A bug where spells not in the spellbook caused an error for the action bar tooltip.**

## [v0.3.8.2-release] - 11/25/2023

### Fixed:

- **Good news! We've fixed a bug that affected how the crit log displayed information for spells that can both heal and
  damage. Previously, if a spell had both of these capabilities, the crit log wasn't displaying correctly.**

- **This issue did not affect spells that were exclusively for healing or damage. With this latest update, you can
  expect accurate and consistent display for all spells, regardless of whether they heal, damage, or do both.**

- **Thank you for your continued support and feedback, which helps us improve CritMatic. Enjoy your enhanced gaming
  experience!**

## [v0.3.8-release] - 11/24/2023

### Updated:

- **Changed the spell data handling from using spell names to spell IDs. This update enhances localization support,
  allowing CritMatic to be more compatible with different language settings and paving the way for future international
  releases.**

- **Due to this change, existing spell data in CritMatic had to be cleared. We apologize for any inconvenience this may
  cause and appreciate your understanding.**

## [v0.3.7.1-release] - 11/20/2023

### Updated:

- **Crit Log now sorts by latest Crits/Hits/Crit Heals/Heals.**

## [v0.3.7-release] - 11/19/2023

### Added:

- **New CritLog widget, that displays your latest Crits/Normal Hits/CritHeals/Heals. Open it with /cmcritlog that
  you can macro.**

## [v0.3.6.2.5-release] - 11/12/2023

### Fixed:

- **Turning off social messages was not working its fixed now.**

## [v0.3.6.2.4-release] - 11/12/2023

### Fixed:

- **Addressed the issue where critical hits (crits) were not consistently displayed correctly in the CritMatic addon, a
  bug fix has been implemented. This should resolve the intermittent inaccuracies in the alerts and chat crit display.**

- **a bug has been fixed that was preventing new critical hits (crits) from being announced in battlegrounds, raids, and
  parties. This update ensures that crit announcements are correctly broadcasted in these group environments.**

## [v0.3.8-release] - 11/24/2023

### Updated:

- **Changed the spell data handling from using spell names to spell IDs. This update enhances localization support,
  allowing CritMatic to be more compatible with different language settings and paving the way for future international
  releases.**

- **Due to this change, existing spell data in CritMatic had to be cleared. We apologize for any inconvenience this may
  cause and appreciate your understanding.**

## [v0.3.7.1-release] - 11/20/2023

### Updated:

- **Crit Log now sorts by latest Crits/Hits/Crit Heals/Heals.**

## [v0.3.7-release] - 11/19/2023

### Added:

- **New CritLog widget, that displays your latest Crits/Normal Hits/CritHeals/Heals. Open it with /cmcritlog that
  you can macro.**

## [v0.3.6.2.5-release] - 11/12/2023

### Fixed:

- **Turning off social messages was not working its fixed now.**

## [v0.3.6.2.4-release] - 11/12/2023

### Fixed:

- **Addressed the issue where critical hits (crits) were not consistently displayed correctly in the CritMatic addon, a
  bug fix has been implemented. This should resolve the intermittent inaccuracies in the alerts and chat crit display.**

- **a bug has been fixed that was preventing new critical hits (crits) from being announced in battlegrounds, raids, and
  parties. This update ensures that crit announcements are correctly broadcasted in these group environments.**

## [v0.3.6.2.3-release] - 11/11/2023

### Fixed:

- **Broadcast Bug in CritMatic. Resolved an issue in CritMatic:BroadcastVersion(). Ensures accurate new version
  notifications across WoW Classic, Wrath, and Retail. Please update for improved functionality and version
  notifications.**

## [v0.3.6.2.2-release] - 11/10/2023

### Fixed:

- **Various fixes.**

## [v0.3.6.2.1-release] - 11/4/2023

### Fixed:

- **We've rolled out a series of tweaks and fixes to enhance stability and performance.**

## [v0.3.6.2-release] - 11/4/2023

### Fixed:

- **We've patched up the 'New Version' pop-up to ensure it's functioning smoothly. You should now receive a pop-up when
  an update is available, keeping you in the loop with the latest enhancements.**

## [v0.3.5.9.6-release] - 11/4/2023

### Updated:

- **We've overhauled the internal code structure for the Options Tables to pave the way for an exciting new feature
  dubbed "CritLog." Picture a widget similar to the Deathlog addon, which you can toggle on or off. The CritLog will
  track and display your critical strikes, regular hits, critical heals, and standard heals. Accessing this feature will
  be a breeze with the new slash command `/cmlog`. Stay tuned as we begin the development phase!**

- **We've updated the font color for the "CritMatic Loaded" notification for better visibility and style.**

## [v0.3.5.9-release] - 11/3/2023

### Fixed:

- **The change log should now reflect new changes correctly.**
- **Various other fixes**

## [v0.3.5.8-release] - 11/3/2023

### Fixed:

- **Resolved an issue where critical hit notifications were failing to dispatch in battleground instances.**

### Added:

- ** Added a toggle to disable broadcasting critical hit alerts in battlegrounds.**

## [v0.3.5.7-release] - 11/2/2023

### Fixed:

- **Resolved an edge-case condition where CritMatic erroneously reported 'not in a party or raid' within battlegrounds
  and arenas.**

### Added:

- ** An automated changelog pop-up to brief you on the latest patches. Run /cmlog anytime.**

## [v0.3.5.3-release] - 10/29/2023

### Fixed:

- **Various Fixes.**

## [v0.3.5.1-release] - 10/29/2023

### Fixed:

- **Removed extraneous debug log invocations.**

## [v0.3.5-release] - 10/28/2023

### Added:

- **Extended compatibility to include WoW Retail through API adjustments.**

## [v0.3.4.1-release] - 10/28/2023

### Added:

- **Implemented options for broadcasting critical events to Raid and Guild channels.**

## [v0.3.3-release] - 10/28/2023

### Added:

- **Introduced version-checking mechanism to notify users of outdated CritMatic versions.**

## [v0.3.2-release] - 10/26/2023

### Updated:

- **Refined various functional and UI elements.**

### Added:

- **Introduced generalized configuration options.**

## [v0.3.1-release] - 10/26/2023

### Fixed:

- **Purged residual debug messages inadvertently left in production build.**

### Updated:

- **Optimized Party Notifications to exclusively display Critical Hits and Heals, omitting standard events.**

### Added:

- **Included toggle for silencing party notifications.**

## [v0.3.0-release] - 10/25/2023

### Added:

- **New Slash Commands to open the options menu /cm and /critmatic**
- **You can Change the Crit and Normal hit / heal sounds.**

## [v0.2.9.1-release] - 10/22/2023

### Updated:

- **Hotfix deployed for urgent issues.**

### Added:

- **Configurable options for disabling chat and alert notifications introduced.**

## [v0.2.8-release] - 10/21/2023

### Added:

- **Optionality added for tracking auto-attacks.**

## [v0.2.5.7-release] - 9/27/2023

### Updated:

- **General improvements and bug fixes.**

## [v0.2.5.6-release] - 9/27/2023

### Updated:

- **Minor revisions and optimizations.**

## [v0.2.5.5-release] - 9/26/2023

### Fixed:

- **Rectified various issues and bugs.**

## [v0.2.3-release] - 9/19/2023

### Fixed:

- **Resolved issue with settings not persisting across sessions.**

### Updated:

- **Adjusted default font size to 22 and introduced a 0.45s delay for notification messages.**

## [v0.2.2-release] - 9/17/2023

### Updated:

- **Modified default font size to 24 and added a 0.25s delay to notification messages.**

## [v0.2.1.5-release] - 9/12/2023

### Fixed:

- **Addressed multiple bugs and issues.**

## [v0.2.1-release] - 9/10/2023

### Added:

- **Incorporated settings for font customization.**

## [v0.2.0-release] - 9/05/2023

### Added:

- **Slash Commands `/cm` and `/critmatic` introduced for options menu.**
- **Sound settings for Crit and Normal hits/heals are now customizable.**

## [v0.1.6.5-release] - 9/01/2023

### Updated:

- **Enhanced notification animations.**

## [v0.1.6-release] - 8/29/2023

### Fixed:

- **Addressed a bug causing the first notification for Crit/Normal/Heal events to not display upon game start.**

## [v0.1.5.6-release] - 8/28/2023

### Added:

- **Introduced a distinct sound effect for Normal Heals.**

## [v0.1.5.5-release] - 8/27/2023

### Fixed:

- **Resolved a bug causing the absence of sound for normal hit/heals.**

### Added:

- **Extended support for Classic Era / Hardcore.**
- **Updated Notification Animation.**

## [v0.1.4-alpha] - 8/23/2023

### Added:

- **New Crit animations introduced.**
- **Tooltip information for CritMatic added to the spell-book.**

## [v0.1.3-alpha] - 8/20/2023

### Fixed:

- **Addressed an issue causing premature disappearance of hit messages.**

## [v0.1.2-alpha] - 8/18/2023

### Added:

- **Implemented a cap for extremely high-value crits, heals, and hits.**
- **Added a validation check to prevent tracking of non-spellbook spells.**
