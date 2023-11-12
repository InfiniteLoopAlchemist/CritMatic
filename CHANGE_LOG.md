## [v0.3.6.2.5-release] - 11/12/2023

### Fixed:

- **Turning off social messages was not working its fixed now.**



## [v0.3.6.2.4-release] - 11/12/2023

### Fixed:

- **Addressed the issue where critical hits (crits) were not consistently displayed correctly in the CritMatic addon, a bug fix has been implemented. This should resolve the intermittent inaccuracies in the alerts and chat crit display.**

- **a bug has been fixed that was preventing new critical hits (crits) from being announced in battlegrounds, raids, and parties. This update ensures that crit announcements are correctly broadcasted in these group environments.**



## [v0.3.6.2.3-release] - 11/11/2023

### Fixed:

- **Broadcast Bug in CritMatic. Resolved an issue in CritMatic:BroadcastVersion(). Ensures accurate new version notifications across WoW Classic, Wrath, and Retail. Please update for improved functionality and version notifications.**



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
