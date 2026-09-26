local utils = ambient_sounds.adapter_utils

local prairie = {{name = "ambient_sounds_ethereal_prairie_main", gain = 0.5}}
local quiet_night = {{name = "ambient_sounds_night_main_3", gain = 0.15}}
local wind_day = {{name = "ambient_sounds_howling_wind", gain = 0.2}}
local wind_night = {{name = "ambient_sounds_howling_wind", gain = 0.3}}
local snow = {{name = "ambient_sounds_snowy_biomes_main_1", gain = 0.4}}
local cicadas = {{name = "ambient_sounds_cicadas_desert_1", pitch = 0.9, gain = 0.35}}

utils.register_day_night("icesheet", {"icesheet"}, wind_night, wind_night)
utils.register_day_night("tundra", {"tundra"}, snow, wind_night)
utils.register_day_night("taiga", {"taiga"}, wind_day, wind_night)
utils.register_day_night("snowy", {"snowy_grassland"}, snow, wind_night)
utils.register_day_night("plains", {"grassland"}, prairie, quiet_night)
utils.register_day_night("coniferous_forest", {"coniferous_forest"}, snow, wind_night)
utils.register_day_night("deciduous_forest", {"deciduous_forest"}, {
    {name = "ambient_sounds_ethereal_prairie_main", gain = 0.5},
    {name = "ambient_sounds_leaves_wind", gain = 0.05},
}, quiet_night)
utils.register_day_night("desert", {"desert", "sandstone_desert", "cold_desert"}, cicadas, cicadas)
utils.register_day_night("savanna", {"savanna"}, cicadas, {
    {name = "ambient_sounds_savanna_main_night", gain = 0.15},
})
utils.register_day_night("rainforest", {"rainforest"}, {
    {name = "ambient_sounds_jungle_main", gain = 0.3},
}, {
    {name = "ambient_sounds_jungle_main_night", gain = 0.3},
})

local water_nodes = {"default:water_source", "default:water_flowing"}
local ocean_biomes = {
    "icesheet_ocean", "tundra_ocean", "taiga_ocean",
    "snowy_grassland_ocean", "grassland_ocean", "coniferous_forest_ocean",
    "deciduous_forest_ocean", "desert_ocean", "sandstone_desert_ocean",
    "cold_desert_ocean", "savanna_ocean", "rainforest_ocean",
}

utils.register_ocean(water_nodes, ocean_biomes)
utils.register_pond(water_nodes, {"deciduous_forest_night", "plains_night"})
utils.register_defaults()