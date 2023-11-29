-- (Russian) localization file for ruRU clients.
local debug = false
--@debug@ debug = true --@end-debug@
local L = LibStub("AceLocale-3.0"):NewLocale("CritMatic", "ruRU", false, debug)
--@localization(locale="ruRU", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
if not L then return end
--CritMatic.lua
L["action_bar_crit"] = true
L["action_bar_hit"] = true
L["action_bar_dps"] = true
L["action_bar_crit_heal"] = true
L["action_bar_heal"] = true
L["action_bar_hps"] = true
L["new_version_notification_part"] = true
L["slash_critmatic"] = "critmatic"
L["slash_cm"] = "cm"
L["slash_cmlog"] = true
L["slash_cmcritlog"] = true
L["slash_cmreset"] =true
L["version_string"] = true
L["critmatic_loaded"] = true
L["critmatic_loaded_2"] = "/cm"
L["critmatic_loaded_3"] = true
L["critmatic_loaded_4"] = true
L["critmatic_loaded_5"] = true
L["critmatic_loaded_6"] = true
L["critmatic_loaded_7"] = true
L["critmatic_reset"] = true
L["chat_crit"] = true
L["chat_hit"] = true
L["chat_crit_heal"] = true
L["chat_heal"] = true
L["social_crit"] = true
L["social_crit_heal"] = true
-- messageFrame.lua and CritLog.lua
L["message_log_crit"] = true
L["message_log_hit"] = true
L["message_log_heal"] = true
L["message_log_new"] = true
L["message_log_old"] = true
L["message_log_critmatic"] = "CritMatic"

-- CritMaticOptions.lua
-- General
L["options_general"] = true
L["options_auto_attacks"] = true
L["options_auto_attacks_desc"] = true
L["options_show_chat_notifications"] = true
L["options_show_chat_notifications_desc"] = true
L["options_show_alert_notifications"] = true
L["options_show_alert_notifications_desc"] = true
L["options_show_change_log"] = true
L["options_show_change_log_desc"] = true
L["options_discord_link"] = true
L["options_discord_link_desc"] = true
L["options_discord_link_copy"] = true

-- Alert Font Settings
L["options_alert_font_settings"] = true
L["options_alert_font"] = true
L["options_alert_font_desc"] = true
L["options_alert_font_size"] = true
L["options_alert_font_color_crit"] =true
L["options_alert_font_color_crit_desc"] = true
L["options_alert_font_c_non_crit"] = true
L["options_alert_font_c_non_crit_desc"] = true
L["options_alert_font_outline"] = true
L["options_alert_font_none"] = true
L["options_alert_font_outline_mono"] = true
L["options_alert_font_outline_thick"] = true
L["options_alert_font_outline_thick_mono"] = true
L["options_alert_font_shadow_x"] = true
L["options_alert_font_shadow_x_desc"] = true
L["options_alert_font_shadow_y"] = true
L["options_alert_font_shadow_y_desc"] = true
L["options_alert_font_shadow_color"] = true
L["options_alert_font_shadow_color_desc"] = true
L["options_alert_font_reset"] = true
L["options_alert_font_reset_desc"] = true
L["options_alert_font_reset_confirm"] = true

-- Sound Settings
L["options_sound_settings"] = true
L["options_sound_crit"] = true
L["options_sound_hit"] = true
L["options_sound_crit_heal"] = true
L["options_sound_heal"] = true
L["options_sound_mute_all"] = true
L["options_sound_mute_all_desc"] = true
L["options_sound_reset"] = true
L["options_sound_reset_desc"] = true

-- Social Settings
L["options_social"] = true
L["options_social_send_crits_toParty"] = true
L["options_social_send_crits_toParty_desc"] = true
L["options_social_send_crits_toRaid"] = true
L["options_social_send_crits_toRaid_desc"] = true
L["options_social_send_crits_toGuild"] = true
L["options_social_send_crits_toGuild_desc"] = true
L["options_social_send_crits_toBattleGrounds"] = true
L["options_social_send_crits_toBattleGrounds_desc"] = true

-- Change Log Settings
L["options_change_log"] = true
L["options_change_log_font"] = true
L["options_change_log_font_desc"] = true
L["options_change_log_font_size"] = true
L["options_change_log_font_color"] = true
L["options_change_log_font_color_desc"] = true
L["options_change_log_font_outline"] = true
L["options_change_log_font_none"] = true
L["options_change_log_font_outline_mono"] = true
L["options_change_log_font_outline_thick"] = true
L["options_change_log_font_outline_thick_mono"] = true
L["options_change_log_reset"] = true
L["options_change_log_reset_desc"] = true
L["options_change_log_reset_confirm"] = true


L["options_change_log_border_and_background"] = true
L["options_change_log_border_and_background_border"] = true
L["options_change_log_border_and_background_border_desc"] = true
L["options_change_log_border_and_background_border_size"] = true
L["options_change_log_border_and_background_border_size_desc"] = true
L["options_change_log_border_and_background_texture"] = true
L["options_change_log_border_and_background_texture_desc"] = true
L["options_change_log_border_and_background_reset"] = true
L["options_change_log_border_and_background_reset_desc"] = true
L["options_change_log_border_and_background_reset_confirm"] =true