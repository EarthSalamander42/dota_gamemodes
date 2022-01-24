if GameMode == nil then
	_G.GameMode = class({})
end

-- require('libraries/adv_log') -- be careful! this library can hide lua errors in rare cases

require('libraries/notifications')
require('libraries/player')
require('libraries/player_resource')
require('libraries/selection') -- For Turbo Couriers
require('libraries/timers')

require('internal/gamemode')
require('internal/events')

-- add components below the api
require("components/demo/init")
require('components/settings/settings')

require('events/events')
require('filters')

-- Use this function as much as possible over the regular Precache (this is Async Precache)
function GameMode:PostLoadPrecache()
	
end

function GameMode:OnFirstPlayerLoaded()
	
end

function GameMode:OnAllPlayersLoaded()
	-- Setup filters
--	GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap(GameMode, "HealingFilter"), self )
--	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
--	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
--	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldFilter"), self)
--	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ExperienceFilter"), self)
--	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierFilter"), self)
--	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(GameMode, "ItemAddedFilter"), self)
--	GameRules:GetGameModeEntity():SetBountyRunePickupFilter(Dynamic_Wrap(GameMode, "BountyRuneFilter"), self)
	GameRules:GetGameModeEntity():SetThink("OnThink", self, 1)
	GameRules:GetGameModeEntity():SetPauseEnabled(false)

	GameRules:GetGameModeEntity():SetRuneSpawnFilter(Dynamic_Wrap(GameMode, "RuneSpawnFilter"), self)
end

-- CAREFUL, FOR REASONS THIS FUNCTION IS ALWAYS CALLED TWICE
function GameMode:InitGameMode()
	self:_InitGameMode()
end
