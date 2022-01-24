require('events/npc_spawned/on_hero_spawned')
require('events/npc_spawned/on_unit_spawned')
require('events/on_entity_killed/on_hero_killed')

function GameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
--		Timers:CreateTimer(1.0, function()
--			PlayerResource:SetCustomTeamAssignment(0, 2)
--		end)

		Timers:CreateTimer(2.0, function()
			SendToServerConsole('sm_gmode 1')
			SendToServerConsole('dota_bot_populate')
		end)
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then

	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:IsValidPlayer(i) and not PlayerResource:HasSelectedHero(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
				PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
				PlayerResource:SetCanRepick(i, false)
			end
		end
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then

	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
--[[
		-- temporary gold earning through old tick time, until couriers are fixed
		Timers:CreateTimer(function()
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then return nil end

			for i = 0, PlayerResource:GetPlayerCount() - 1 do
				if PlayerResource:IsValidPlayerID(i) then
					PlayerResource:ModifyGold(i, 1, true, DOTA_ModifyGold_GameTick)
				end
			end

			return GOLD_TICK_TIME[GetMapName()]
		end)
--]]
	end
end

function GameMode:OnNPCSpawned(keys)
	GameMode:_OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc then
		-- UnitSpawned Api Event
		local player = "-1"

		if npc:IsRealHero() and npc:GetPlayerID() then
			player = PlayerResource:GetSteamID(npc:GetPlayerID())
		end

		if npc:IsRealHero() or npc:IsFakeHero() or npc:IsClone() then
			if npc.first_spawn ~= true then
				npc.first_spawn = true

				-- Need a frame time to detect illusions
				Timers:CreateTimer(FrameTime(), function()
					GameMode:OnHeroFirstSpawn(npc)
				end)

				return
			end

			GameMode:OnHeroSpawned(npc)

			return
		else
			if npc.first_spawn ~= true then
				npc.first_spawn = true
				GameMode:OnUnitFirstSpawn(npc)

				return
			end

			GameMode:OnUnitSpawned(npc)

			return
		end
	end
end

function GameMode:OnDisconnect(keys)
	-- GetConnectionState values:
	-- 0 - no connection
	-- 1 - bot connected
	-- 2 - player connected
	-- 3 - bot/player disconnected.

	-- Typical keys:
	-- PlayerID: 2
	-- name: Zimberzimber
	-- networkid: [U:1:95496383]
	-- reason: 2
	-- splitscreenplayer: -1
	-- userid: 7
	-- xuid: 76561198055762111

	-- IMBA: Player disconnect/abandon logic
	-- If the game hasn't started, or has already ended, do nothing
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
		return nil
		-- Else, start tracking player's reconnect/abandon state
	else
		-- Fetch player's player and hero information
		if keys.PlayerID == nil or keys.PlayerID == -1 then
			return
		end

		local player_id = keys.PlayerID
		local player_name = keys.name

		if PlayerResource:GetPlayer(player_id):GetAssignedHero() == nil then
			return
		end

		local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
	end
end

-- An entity died
function GameMode:OnEntityKilled(keys)
	GameMode:_OnEntityKilled(keys)

	-- The Unit that was killed
	local killed_unit = EntIndexToHScript(keys.entindex_killed)

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker then
		killer = EntIndexToHScript(keys.entindex_attacker)
	end

	if killed_unit then
		------------------------------------------------
		-- Api Event Unit Killed
		------------------------------------------------

		killedUnitName = tostring(killed_unit:GetUnitName())

		if (killedUnitName ~= "") then
			killedPlayer = "-1"

			if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then
				killedPlayerId = killed_unit:GetPlayerID()
				killedPlayer = PlayerResource:GetSteamID(killedPlayerId)
			end

			killerUnitName = "-1"
			killerPlayer = "-1"

			if (killer ~= nil) then
				killerUnitName = tostring(killer:GetUnitName())
				if (killer:IsRealHero() and killer:GetPlayerID()) then
					killerPlayerId = killer:GetPlayerID()
					killerPlayer = PlayerResource:GetSteamID(killerPlayerId)
				end
			end
		end

		-------------------------------------------------------------------------------------------------
		-- IMBA: Ancient destruction detection
		-------------------------------------------------------------------------------------------------
		if killed_unit:GetUnitName() == "npc_dota_badguys_fort" then
			GAME_WINNER_TEAM = 2
			return
		elseif killed_unit:GetUnitName() == "npc_dota_goodguys_fort" then
			GAME_WINNER_TEAM = 3
			return
		end

		-- Check if the dying unit was a player-controlled hero
		if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then
			GameMode:OnHeroDeath(killer, killed_unit)

			if IMBA_GOLD_SYSTEM == true then
				GoldSystem:OnHeroDeath(killer, killed_unit)
			end

			return
		end

		if killed_unit.pedestal then
			killed_unit.pedestal:ForceKill(false)
		end
	end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	local entIndex = keys.index + 1
	local ply = EntIndexToHScript(entIndex)
	local playerID = ply:GetPlayerID()
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
	--	local playerID = self.vUserIds[userID]:GetPlayerID()

	local text = keys.text

	local steamid = tostring(PlayerResource:GetSteamID(keys.playerid))

	-- This Handler is only for commands, ends the function if first character is not "-"
	if not (string.byte(text) == 45) then
		return nil
	end

	local caster = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

	for str in string.gmatch(text, "%S+") do
		if str == "-replaceherowith" then
			text = string.gsub(text, str, "")
			text = string.gsub(text, " ", "")
			if PlayerResource:GetSelectedHeroName(caster:GetPlayerID()) ~= "npc_dota_hero_" .. text then
				if caster.companion then
					caster.companion:ForceKill(false)
					caster.companion = nil
				end

				local old_hero = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerID())

				PrecacheUnitByNameAsync("npc_dota_hero_" .. text, function()
					PlayerResource:ReplaceHeroWith(caster:GetPlayerID(), "npc_dota_hero_" .. text, 0, 0)

					Timers:CreateTimer(1.0, function()
						if old_hero then
							UTIL_Remove(old_hero)
						end
					end)
				end)
			end
		end

		-- When you don't want to have random match history...
		if str == "-crashgame" then
			print(PlayerResource:GetPlayerName(caster:GetPlayerID()), "(", PlayerResource:GetSteamID(caster:GetPlayerID()), ") has called a crash command.")
			Notifications:BottomToAll({ text = "Game is attempting to be crashed by "..PlayerResource:GetPlayerName(caster:GetPlayerID()).." in 5 seconds.", duration = 5.0, style = { color = "Red" } })
			
			-- Others may be potentially abusing this so putting a failsafe
			-- Crash if teams are less than half full (likely just testing stuff), otherwise make them auto-lose for attempting to crash
			Timers:CreateTimer(5.0, function()
				if PlayerResource:GetPlayerCountForTeam(caster:GetTeam()) / GameRules:GetCustomGameTeamMaxPlayers(caster:GetTeam()) < 0.5 then
					caster:AddNewModifier(caster, nil, nil, {})
				else
					GameRules:MakeTeamLose(caster:GetTeam())
				end
			end)
		end

		if str == "-toggle_ui" then
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "toggle_ui", {})
		end

		if str == "-same_heroes" then
			GameRules:SetSameHeroSelectionEnabled( true )
			CustomNetTables:SetTableValue("game_options", "same_hero_pick", {value = true})
		end

		-- For the serial disconnectors
		if str == "-exit" then
			GameRules:SetGameWinner(caster:GetOpposingTeamNumber())
		end
	end
end

function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	return 1
end
