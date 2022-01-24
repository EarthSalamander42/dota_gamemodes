function GameMode:OnHeroDeath(killer, victim)
	local hero = victim

	if victim:IsClone() then
		hero = victim:GetCloneSource()
	end
end
