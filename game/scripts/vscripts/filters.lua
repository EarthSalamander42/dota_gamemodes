-- Gold gain filter function
function GameMode:GoldFilter(keys)
	-- reason_const		12
	-- reliable			1
	-- player_id_const	0
	-- gold				141

	-- Ignore negative gold values
	if keys.gold <= 0 then
		return false
	end

	-- Gold from abandoning players does not get multiplied
	if keys.reason_const == DOTA_ModifyGold_AbandonedRedistribute or keys.reason_const == DOTA_ModifyGold_GameTick then
		return true
	end

	if PlayerResource:GetPlayer(keys.player_id_const) == nil then return end
	local player = PlayerResource:GetPlayer(keys.player_id_const)

	-- player can be nil for some reason
	if player then
		local hero = player:GetAssignedHero()
		if hero == nil then return end
	end

	return true
end

-- Experience gain filter function
function GameMode:ExperienceFilter( keys )
	-- reason_const		1 (DOTA_ModifyXP_CreepKill)
	-- experience		130
	-- player_id_const	0

	-- Ignore negative experience values
	if keys.experience < 0 then
		return false
	end

	-- Testing exp multiplier based on networth differentials
	local player = PlayerResource:GetPlayer(keys.player_id_const)

	if player == nil then return end

	local hero = player:GetAssignedHero()

	if hero == nil then return end

	return true
end

function GameMode:RuneSpawnFilter(keys)
    keys.rune_type = RandomInt(0, 5)
    
    if keys.rune_type == 5 then
        keys.rune_type = keys.rune_type + 1
    end
    
    return true
end
