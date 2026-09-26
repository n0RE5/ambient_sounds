local utils = ambient_sounds.adapter_utils

local prairie = {{name = "ambient_sounds_ethereal_prairie_main", gain = 0.5}}
local quiet_night = {{name = "ambient_sounds_night_main_3", gain = 0.15}}
local cicadas = {{name = "ambient_sounds_cicadas_desert_1", pitch = 0.9, gain = 0.35}}
local jungle_day = {{name = "ambient_sounds_jungle_main", gain = 0.3}}
local jungle_night = {{name = "ambient_sounds_jungle_main_night", gain = 0.3}}

utils.register_day_night("bamboo", {"bamboo"}, prairie, quiet_night)
utils.register_day_night("grassytwo", {"grassytwo"}, prairie, quiet_night)
utils.register_day_night("prairie", {"prairie"}, prairie, quiet_night)
utils.register_day_night("grove", {"grove", "jumble", "mediterranean"}, prairie, quiet_night)
utils.register_day_night("mesa", {"mesa", "mesa_redwood", "mesa_beach"}, cicadas, {
    {name = "ambient_sounds_savanna_main_night", gain = 0.15},
})
utils.register_day_night("mushroom", {"mushroom"}, jungle_day, quiet_night)
utils.register_day_night("grayness", {"grayness"}, {
    {name = "ambient_sounds_leaves_wind", gain = 0.04},
}, quiet_night)
utils.register_day_night("frost", {"frost"}, {
    {name = "ambient_sounds_howling_wind", gain = 0.2},
}, quiet_night)
utils.register_day_night("fiery", {"fiery"}, {
    {name = "ambient_sounds_ethereal_fiery_main", gain = 0.08},
}, {
    {name = "ambient_sounds_ethereal_fiery_main", gain = 0.08},
})
utils.register_day_night("ethereal_plains", {"plains"}, {
    {name = "ambient_sounds_snowy_biomes_main_1", gain = 0.15},
}, {
    {name = "ambient_sounds_savanna_main_night", gain = 0.15},
})
utils.register_day_night("swamp", {"swamp", "mangrove"}, jungle_day, jungle_night)
utils.register_day_night("mountain", {"mountain"}, {
    {name = "ambient_sounds_howling_wind", gain = 0.2},
}, {
    {name = "ambient_sounds_howling_wind", gain = 0.3},
})
utils.register_day_night("caves", {"caves"}, cicadas, cicadas)