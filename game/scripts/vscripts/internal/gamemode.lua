-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later

function GameMode:_InitGameMode()
	if self._reentrantCheck then
		return
	end

	-- Setup rules
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( false ) -- Let server handle hero duplicates
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetHeroSelectPenaltyTime( SELECT_PENALTY_TIME )
	GameRules:SetPreGameTime( 90 ) -- Some variable SOMEWHERE is messing this up and constantly forcing it to 60 seconds so I'm overriding it here
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetShowcaseTime( SHOWCASE_TIME )
	GameRules:SetStrategyTime( STRATEGY_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
	GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )
	GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
	
	GameRules:SetUseCustomHeroXPValues ( USE_NONSTANDARD_HERO_XP_BOUNTY )
	GameRules:SetUseBaseGoldBountyOnHeroes( USE_NONSTANDARD_HERO_GOLD_BOUNTY )

	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_DOUBLEDAMAGE , true) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_HASTE, true) --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_ILLUSION, true) --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_INVISIBILITY, true) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_REGENERATION, true) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_ARCANE, true) --Arcane
--	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_BOUNTY, false) --Bounty

	GameRules:LockCustomGameSetupTeamAssignment(not IsInToolsMode())

--	GameRules:SetCustomGameTeamMaxPlayers(2, 1)

--	GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(AP_GAME_TIME)
--	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride(AP_BAN_TIME)

	-- team colors are not working in chat, so use team colors instead
--	SetTeamCustomHealthbarColor(DOTA_TEAM_GOODGUYS, 0, 128, 0)
--	SetTeamCustomHealthbarColor(DOTA_TEAM_BADGUYS, 128, 0, 0)

	-- WHY DON'T YOU WORK FOR CHAT PLAYER COLORS, WHAT HAPPENED TO YOU BUDDY
--	for ID = 0, PlayerResource:GetPlayerCount() - 1 do
--		if PlayerResource:IsValidPlayer(ID) then
--			PlayerResource:SetCustomPlayerColor(ID, PLAYER_COLORS[ID][1], PLAYER_COLORS[ID][2], PLAYER_COLORS[ID][3])
--		end
--	end

	-- Event Hooks
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, '_OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(self, '_OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(self, 'OnDisconnect'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, '_OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(self, '_OnNPCSpawned'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(self, 'OnPlayerReconnect'), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(self, 'OnPlayerChat'), self)

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '^0+','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.bSeenWaitForPlayers = false
	self.vUserIds = {}

	self._reentrantCheck = true
	self:InitGameMode()
	self._reentrantCheck = false
end

local mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:_CaptureGameMode()
	if mode == nil then
		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( false )
--		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
--		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
--		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( false )
		mode:SetTopBarTeamValuesVisible( true )
--		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
--		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
		mode:SetBotThinkingEnabled( true )
--		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

--		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
--		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

--		mode:SetFixedRespawnTime( -1 ) 
--		mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
--		mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
--		mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
--		mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
--		mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
--		mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )

--		mode:SetHudCombatEventsDisabled(IMBA_COMBAT_EVENTS)

		self:OnFirstPlayerLoaded()
	end
end
