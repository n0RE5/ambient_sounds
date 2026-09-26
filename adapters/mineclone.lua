local utils = ambient_sounds.adapter_utils

local prairie = {{name = "ambient_sounds_ethereal_prairie_main", gain = 0.5}}
local quiet_night = {{name = "ambient_sounds_night_main_3", gain = 0.15}}
local wind_day = {{name = "ambient_sounds_howling_wind", gain = 0.2}}
local wind_night = {{name = "ambient_sounds_howling_wind", gain = 0.3}}
local snow = {{name = "ambient_sounds_snowy_biomes_main_1", gain = 0.4}}
local cicadas = {{name = "ambient_sounds_cicadas_desert_1", pitch = 0.9, gain = 0.35}}
local jungle_day = {{name = "ambient_sounds_jungle_main", gain = 0.3}}
local jungle_night = {{name = "ambient_sounds_jungle_main_night", gain = 0.3}}

utils.register_day_night("icesheet", {
    "IcePlainsSpikes", "IceSpikes",
}, wind_night, wind_night)
utils.register_day_night("tundra", {
    "IcePlains", "SnowyPlains", "SnowySlopes", "FrozenPeaks",
    "JaggedPeaks", "FrozenRiver", "SnowyBeach",
}, snow, wind_night)
utils.register_day_night("taiga", {
    "ColdTaiga", "ColdTaiga_beach", "SnowyTaiga",
}, wind_day, wind_night)
utils.register_day_night("snowy", {"Grove"}, snow, wind_night)
utils.register_day_night("plains", {
    "Plains", "Plains_beach", "Meadow", "Meadow_beach", "SunflowerPlains",
}, prairie, quiet_night)
utils.register_day_night("coniferous_forest", {
    "Taiga", "Taiga_beach", "MegaTaiga", "MegaSpruceTaiga",
    "OldGrowthPineTaiga", "OldGrowthSpruceTaiga",
}, snow, wind_night)
utils.register_day_night("deciduous_forest", {
    "Forest", "FlowerForest", "FlowerForest_beach", "BirchForest", "BirchForestM",
    "Forest_beach", "RoofedForest", "DarkForest", "PaleGarden",
    "OldGrowthBirchForest", "CherryGrove",
}, {
    {name = "ambient_sounds_ethereal_prairie_main", gain = 0.5},
    {name = "ambient_sounds_leaves_wind", gain = 0.05},
}, quiet_night)
utils.register_day_night("desert", {"Desert"}, cicadas, cicadas)
utils.register_day_night("mesa", {
    "Mesa", "Mesa_sandlevel", "MesaBryce", "MesaBryce_sandlevel",
    "MesaPlateauF", "MesaPlateauF_grasstop", "MesaPlateauF_sandlevel",
    "MesaPlateauFM", "MesaPlateauFM_grasstop", "MesaPlateauFM_sandlevel",
    "ErodedMesa", "WoodedMesa",
}, cicadas, {
    {name = "ambient_sounds_savanna_main_night", gain = 0.15},
})
utils.register_day_night("savanna", {
    "Savanna", "Savanna_beach", "SavannaM", "Savannah", "SavannahPlateau",
    "WindsweptSavannah",
}, cicadas, {
    {name = "ambient_sounds_savanna_main_night", gain = 0.15},
})
utils.register_day_night("rainforest", {
    "Jungle", "Jungle_shore", "JungleM", "JungleM_shore",
    "JungleEdge", "JungleEdgeM",
    "BambooJungle", "SparseJungle",
}, jungle_day, jungle_night)
utils.register_day_night("swamp", {
    "Swampland", "Swampland_shore", "Swamp",
    "MangroveSwamp", "MangroveSwamp_shore",
}, jungle_day, jungle_night)
utils.register_day_night("mushroom", {
    "MushroomIsland", "MushroomIslandShore", "MushroomIslands",
}, jungle_day, quiet_night)
utils.register_day_night("mountain", {
    "ExtremeHills", "ExtremeHills_beach", "ExtremeHillsM",
    "ExtremeHills+", "ExtremeHills+_snowtop", "StonyPeaks",
    "WindsweptForest", "WindsweptGravellyHills", "WindsweptHills",
}, wind_day, wind_night)

local function in_overworld(pos)
    return not mcl_worlds or mcl_worlds.pos_to_dimension(pos) == "overworld"
end

local water_nodes = {"mcl_core:water_source", "mcl_core:water_flowing"}
local ocean_biomes = {
    "ColdOcean", "DeepColdOcean", "DeepFrozenOcean", "DeepLukewarmOcean",
    "DeepOcean", "FrozenOcean", "LukewarmOcean", "Ocean", "WarmOcean",
    "Beach", "StonyShore", "ColdTaiga_beach_water",
    "IcePlainsSpikes_ocean", "ColdTaiga_ocean", "MegaTaiga_ocean",
    "MegaSpruceTaiga_ocean", "ExtremeHills_ocean", "ExtremeHillsM_ocean",
    "ExtremeHills+_ocean", "StoneBeach_ocean", "IcePlains_ocean",
    "Plains_ocean", "Meadow_ocean", "Grove_ocean", "SunflowerPlains_ocean",
    "Taiga_ocean", "Forest_ocean", "FlowerForest_ocean", "BirchForest_ocean",
    "BirchForestM_ocean", "Desert_ocean", "RoofedForest_ocean", "PaleGarden_ocean",
    "Mesa_ocean", "MesaBryce_ocean", "MesaPlateauF_ocean",
    "MesaPlateauFM_ocean", "Savanna_ocean", "SavannaM_ocean",
    "Jungle_ocean", "JungleM_ocean", "BambooJungle_ocean",
    "JungleEdge_ocean", "JungleEdgeM_ocean", "MangroveSwamp_ocean",
    "Swampland_ocean", "MushroomIsland_ocean",
}

utils.register_ocean(water_nodes, ocean_biomes, in_overworld)
utils.register_pond(water_nodes, {
    "deciduous_forest_night", "plains_night", "swamp_night",
}, in_overworld)
utils.register_defaults(function(tdef)
    return in_overworld(tdef.pos)
end)

local cave_sounds = ambient_sounds.environments.cave.sounds

ambient_sounds.register_environment("mineclone_nether", {
    biomes = {
        "Nether", "NetherWastes", "SoulsandValley", "SoulSandValley",
        "CrimsonForest", "WarpedForest", "BasaltDelta", "BasaltDeltas",
    },
    sounds = {
        {name = "ambient_sounds_ethereal_fiery_main", gain = 0.08}
    },
    priority = 4,
})
ambient_sounds.register_environment("mineclone_end", {
    biomes = {
        "End", "TheEnd", "EndBarrens", "EndMidlands", "EndHighlands",
        "EndSmallIslands", "SmallEndIslands", "EndBorder", "EndIsland",
    },
    sounds = {
        --{name = "ambient_sounds_cave_1", gain = 0.8},
        --{name = "ambient_sounds_cave_2", gain = 1},
        {name = "ambient_sounds_cave_3", gain = 4},
        --{name = "ambient_sounds_cave_large_2", gain = 0.4},
    },
    priority = 4,
})
