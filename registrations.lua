local adapters_path = core.get_modpath("ambient_sounds") .. "/adapters/"
dofile(adapters_path .. "common.lua")

local has_default = core.get_modpath("default")
local has_mineclone = core.get_modpath("mcl_core")
    and core.get_modpath("mcl_biomes")
local has_ethereal = core.get_modpath("ethereal")

if has_mineclone then
    dofile(adapters_path .. "mineclone.lua")
elseif has_default then
    dofile(adapters_path .. "mtg.lua")
else
    core.log("warning", "[Ambient Sounds] No supported game found. Registering defaults")
    ambient_sounds.adapter_utils.register_defaults()
end

if has_ethereal then
    dofile(adapters_path .. "ethereal.lua")
end