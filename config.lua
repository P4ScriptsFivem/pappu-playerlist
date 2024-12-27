Config = {}

-- Text in nui/config.json



-- Debug Settings
Config.Debug = true  -- true - enable debug mode | false - disable debug mode

-- Core Settings
Config.Core = "pappu"  -- Name of the core object

-- Key Settings
Config.OpenKey = 'U'  -- Open playerlist key (Reference: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/)
Config.CloseInstantly = false  -- If false, scoreboard stays open only when OpenKey is held down, otherwise it toggles

-- Player Settings
Config.MaxPlayers = GetConvarInt('sv_maxclients', 10)  -- Max players, default is 10 if Convar is not found
Config.UseIdentifier = "name"  -- Identifier to use for the scoreboard, e.g., "steam", "license", "name" (defaults to citizenid if not found)

-- UI Settings
Config.EnableCharacterName = true  -- Show character name in the scoreboard instead of identifiers
Config.EnableIDAboveHead = true  -- Display ID above the player's head

-- Controls Settings
Config.DisableControls = true  -- Disable controls while scoreboard is open (can be configured further in client.lua)

-- Emote Settings
Config.PlayEmote = false  -- Should play an emote when scoreboard is open? (Plays constantly if EnableIDAboveHead is true)
Config.AnimDict = "misscarsteal4@aliens"  -- Emote animation dictionary
Config.AnimEmote = "rehearsal_base_idle_director"  -- Emote to play

-- Additional Notes
-- If you set `Config.UseIdentifier = "steam"`, ensure that `Config.RequireSteam = false` is enabled in connectqueue
