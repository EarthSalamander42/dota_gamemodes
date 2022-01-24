require('internal/util')
require('gamemode')

function Precache( context )
	LinkLuaModifier("modifier_command_restricted", "components/modifiers/modifier_command_restricted.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_dummy_dummy", "components/modifiers/modifier_dummy_dummy.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_invulnerable_hidden", "components/modifiers/modifier_invulnerable_hidden.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("lm_take_no_damage", "components/modifiers/demo/lm_take_no_damage", LUA_MODIFIER_MOTION_NONE)
end

function Activate()
	print("Activate()")
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
