-- first time a real hero spawn
function GameMode:OnHeroFirstSpawn(hero)
	if not hero or hero:IsNull() then return end

	if hero:IsIllusion() then
		return
	end -- Illusions will not be affected by scripts written under this line
	
	if hero == nil or hero:IsFakeHero() then return end

	local deathEffects = hero:Attribute_GetIntValue("effectsID", -1)
	if deathEffects ~= -1 then
		ParticleManager:DestroyParticle(deathEffects, true)
		hero:DeleteAttribute("effectsID")
	end

	hero.picked = true
end

-- everytime a real hero respawn
function GameMode:OnHeroSpawned(hero)

end
