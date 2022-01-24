GAME_VERSION = "1.0"
-- CustomNetTables:SetTableValue("game_options", "game_version", {value = GAME_VERSION, game_type = CUSTOM_GAME_TYPE})
-- CustomNetTables:SetTableValue("game_options", "gamemode", {1})

PICKING_SCREEN_OVER = false

BOUNTY_RUNE_SPAWN_TIME = 300

-- Barebones constants
AUTO_LAUNCH_DELAY = 10.0
HERO_SELECTION_TIME = 60.0
SELECT_PENALTY_TIME = 0.0
STRATEGY_TIME = 10.0					-- How long should strategy time last?
SHOWCASE_TIME = 0.0					-- How long should showcase time last?
AP_BAN_TIME = 10.0
PRE_GAME_TIME = 90.0
TREE_REGROW_TIME = 180.0				-- How long should it take individual trees to respawn after being cut down/destroyed?
if IsInToolsMode() then
	POST_GAME_TIME = 60000.0				-- How long should we let people look at the scoreboard before closing the server automatically?
else
	POST_GAME_TIME = 600.0					-- How long should we let people look at the scoreboard before closing the server automatically?
end
CAMERA_DISTANCE_OVERRIDE = -1
GOLD_PER_TICK = 1

USE_AUTOMATIC_PLAYERS_PER_TEAM = false		-- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?
UNIVERSAL_SHOP_MODE = false 				-- Should the main shop contain Secret Shop items as well as regular items
if IsInToolsMode() then
	UNIVERSAL_SHOP_MODE = true
end

MINIMAP_ICON_SIZE = 1						-- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1					-- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1					-- What icon size should we use for runes?

-- TODO: Set back to true and fix it
CUSTOM_BUYBACK_COST_ENABLED = false			-- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = false		-- Should we use a custom buyback time?
BUYBACK_ENABLED = true						-- Should we allow people to buyback when they die?

USE_NONSTANDARD_HERO_GOLD_BOUNTY = false	-- Should heroes follow their own gold bounty rules instead of the default DOTA ones?
USE_NONSTANDARD_HERO_XP_BOUNTY = true		-- Should heroes follow their own XP bounty rules instead of the default DOTA ones?
-- Currently setting USE_NONSTANDARD_HERO_XP_BOUNTY to true due to map multipliers making the vanilla values give way too insane level boosts

ENABLE_TOWER_BACKDOOR_PROTECTION = true		-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false			-- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false					-- Should we disable the gold sound when players get gold?

ENABLE_FIRST_BLOOD = true					-- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false					-- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = true					-- Should we have players lose the normal amount of dota gold on death?
ENABLE_TPSCROLL_ON_FIRST_SPAWN = true		-- Should heroes spawn with a TP Scroll?

MAXIMUM_ATTACK_SPEED = 600					-- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 0					-- What should we use for the minimum attack speed?

-------------------------------------------------------------------------------------------------
-- IMBA: map-based settings
-------------------------------------------------------------------------------------------------

MAX_NUMBER_OF_TEAMS = 2														-- How many potential teams can be in this game mode?
IMBA_PLAYERS_ON_GAME = 10													-- Number of players in the game
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = false									-- Should we use custom team colors to color the players/minimap?

PLAYER_COLORS = {}															-- Stores individual player colors
PLAYER_COLORS[0] = { 67, 133, 255 }
PLAYER_COLORS[1]  = { 170, 255, 195 }
PLAYER_COLORS[2] = { 130, 0, 150 }
PLAYER_COLORS[3] = { 255, 234, 0 }
PLAYER_COLORS[4] = { 255, 153, 0 }
PLAYER_COLORS[5] = { 190, 255, 0 }
PLAYER_COLORS[6] = { 255, 0, 0 }
PLAYER_COLORS[7] = { 0, 128, 128 }
PLAYER_COLORS[8] = { 255, 250, 200 }
PLAYER_COLORS[9] = { 49, 49, 49 }

TEAM_COLORS = {}															-- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }							-- Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }							-- Yellow

CUSTOM_TEAM_PLAYER_COUNT = {}
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 5

-------------------------------------------------------------------------------------------------
-- IMBA: game mode globals
-------------------------------------------------------------------------------------------------
GAME_WINNER_TEAM = 0														-- Tracks game winner

IMBA_FIRST_BLOOD = false
