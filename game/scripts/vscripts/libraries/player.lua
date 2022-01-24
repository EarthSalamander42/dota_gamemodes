function CDOTA_BaseNPC:GetNetworth()
	if not self:IsRealHero() then return 0 end
	local gold = self:GetGold()

	-- Iterate over item slots adding up its gold cost
	for i = 0, 15 do
		local item = self:GetItemInSlot(i)
		if item then
			gold = gold + item:GetCost()
		end
	end

	return gold
end

----------------------------------------------------------------------------------
-- credits to yahnich for every functions below
----------------------------------------------------------------------------------

function CDOTA_BaseNPC:IsFakeHero()
	if self:IsIllusion() or (self:HasModifier("modifier_monkey_king_fur_army_soldier") or self:HasModifier("modifier_monkey_king_fur_army_soldier_hidden")) or self:IsTempestDouble() or self:IsClone() then
		return true
	else return false end
end

function CDOTA_BaseNPC:IsRealHero()
	if not self:IsNull() then
		return self:IsHero() and not ( self:IsIllusion() or self:IsClone() ) and not self:IsFakeHero()
	end
end
