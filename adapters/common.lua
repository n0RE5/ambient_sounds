ambient_sounds.adapter_utils = {}
local utils = ambient_sounds.adapter_utils

function utils.is_day(timeofday)
    return timeofday >= 0.25 and timeofday <= 0.75
end

function utils.register_day_night(name, biomes, day_sounds, night_sounds)
    local day = {
        biomes = biomes,
        sounds = day_sounds,
        env_check = function(tdef)
            return utils.is_day(tdef.timeofday)
        end,
        priority = 1,
    }
    ambient_sounds.register_environment(name .. "_day", day)

    local night = {
        biomes = biomes,
        sounds = night_sounds,
        env_check = function(tdef)
            return not utils.is_day(tdef.timeofday)
        end,
        priority = 1,
    }
    ambient_sounds.register_environment(name .. "_night", night)
end

local function count_nodes(totals, node_names)
    local count = 0
    for _, node_name in ipairs(node_names) do
        count = count + (totals[node_name] or 0)
    end
    return count
end

function utils.register_ocean(node_names, biome_names, position_check)
    local ocean_biomes = {}
    for _, biome_name in ipairs(biome_names) do
        ocean_biomes[biome_name] = true
    end

    local function ocean_check(tdef, want_day)
        if utils.is_day(tdef.timeofday) ~= want_day then
            return false
        end
        if position_check and not position_check(tdef.pos) then
            return false
        end
        if ocean_biomes[tdef.biome] then
            return true
        end
        return count_nodes(tdef.totals, node_names)
            > ambient_sounds.config.ocean_water_count
    end

    ambient_sounds.register_environment("ocean_day", {
        sounds = {{name = "ambient_sounds_beach_1", gain = 0.25}},
        env_check = function(tdef)
            return ocean_check(tdef, true)
        end,
        nodes = node_names,
        priority = 2,
    })
    ambient_sounds.register_environment("ocean_night", {
        sounds = {{name = "ambient_sounds_beach_1", gain = 0.25}},
        env_check = function(tdef)
            return ocean_check(tdef, false)
        end,
        nodes = node_names,
        priority = 2,
    })
end

function utils.register_pond(node_names, environments, position_check)
    ambient_sounds.register_subenvironment("pond_night", {
        environments = environments,
        subenv_check = function(tdef)
            if utils.is_day(tdef.timeofday) then
                return false
            end
            if position_check and not position_check(tdef.pos) then
                return false
            end
            return count_nodes(tdef.totals, node_names) > 30
        end,
        nodes = node_names,
        sounds = {{
            name = "ambient_sounds_frogs",
            gain = 0.1,
            pitch = 0.9,
        }},
        priority = 1,
    })
end

function utils.register_defaults(cave_check)
    ambient_sounds.register_environment("cave", {
        y_max = -10,
        sounds = {
            {name = "ambient_sounds_cave_1", gain = 0.5},
            {name = "ambient_sounds_cave_2", gain = 0.4},
            {name = "ambient_sounds_cave_3", gain = 0.5},
            {name = "ambient_sounds_cave_large_2", gain = 0.25},
        },
        env_check = cave_check,
        priority = 3,
    })

    ambient_sounds.register_environment("default", {
        sounds = {{
            name = "ambient_sounds_ethereal_prairie_main",
            gain = 0.3,
        }},
        priority = 0,
    })
end

--- Random sounds registrations
ambient_sounds.register_random_sound({
    name = "ambient_sounds_wolf_howl",
    environments = {
        "deciduous_forest_night", "taiga_night", "tundra_night",
        "coniferous_forest_night", "snowy_night",
    },
    sounds = {{name = "ambient_sounds_wolf_1", gain = 0.6}},
    min_interval = 60,
    max_interval = 120,
    chance = 0.3,
    distance = 50,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_coyote",
    environments = {
        "taiga_day", "taiga_night", "coniferous_forest_day",
        "coniferous_forest_night", "snowy_day", "snowy_night",
    },
    sounds = {{name = "ambient_sounds_coyote", gain = 0.5}},
    min_interval = 30,
    max_interval = 120,
    distance = 20,
    chance = 0.4,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_owl_hoot",
    environments = {
        "deciduous_forest_night", "taiga_day", "taiga_night", "tundra_day",
        "tundra_night", "coniferous_forest_night", "plains_night", "snowy_night",
    },
    sounds = {
        {name = "ambient_sounds_owl_1", gain = 0.5},
        {name = "ambient_sounds_owl_2", gain = 0.5},
        {name = "ambient_sounds_owl_3", gain = 0.5},
    },
    min_interval = 30,
    max_interval = 90,
    distance = 50,
    chance = 0.3,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_eagle_owl",
    environments = {"taiga_night", "tundra_night"},
    sounds = {{name = "ambient_sounds_eagle_owl", gain = 0.08}},
    min_interval = 60,
    max_interval = 120,
    distance = 50,
    chance = 0.25,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_crow",
    environments = {
        "deciduous_forest_day", "plains_day", "grove_day",
        "grayness_day", "grassytwo_day",
    },
    sounds = {
        {name = "ambient_sounds_crow_1", gain = 0.02},
        {name = "ambient_sounds_crow_2", gain = 0.02},
        {name = "ambient_sounds_crow_3", gain = 0.02},
        {name = "ambient_sounds_crow_4", gain = 0.02},
    },
    min_interval = 80,
    max_interval = 120,
    chance = 0.25,
    distance = 50,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_forest_birds",
    environments = {
        "deciduous_forest_day", "plains_day", "bamboo_day", "grove_day",
        "grassytwo_day", "prairie_day",
    },
    sounds = {
        {name = "ambient_sounds_cardinal", gain = 0.92},
        {name = "ambient_sounds_crestedlark", gain = 0.8},
        {name = "ambient_sounds_robin", gain = 0.8},
    },
    min_interval = 25,
    max_interval = 120,
    chance = 0.45,
    distance = 20,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_canadian_loon",
    environments = {"rainforest_day", "rainforest_night", "swamp_day", "swamp_night"},
    sounds = {{name = "ambient_sounds_canadian_loon", gain = 0.5}},
    min_interval = 60,
    max_interval = 120,
    chance = 0.4,
    distance = 50,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_bamboo_flute",
    environments = {
        "rainforest_day", "rainforest_night", "bamboo_day", "bamboo_night",
        "swamp_day", "swamp_night",
    },
    sounds = {{name = "ambient_sounds_flute_2", gain = 0.02}},
    min_interval = 120,
    max_interval = 240,
    chance = 0.3,
    distance = 55,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_seagull",
    environments = {"ocean_day", "icesheet_day", "grove_day"},
    sounds = {
        {name = "ambient_sounds_seagull", gain = 0.5},
        {name = "ambient_sounds_seagull_2", gain = 0.15},
    },
    min_interval = 60,
    max_interval = 120,
    chance = 0.5,
    distance = 70,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_peacock",
    environments = {"savanna_day", "rainforest_day", "bamboo_day", "mesa_day"},
    sounds = {
        {name = "ambient_sounds_peacock_1", gain = 0.85},
        {name = "ambient_sounds_peacock_2", gain = 0.015},
    },
    min_interval = 45,
    max_interval = 120,
    chance = 0.3,
    distance = 20,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_wooden_frog",
    environments = {"rainforest_day", "rainforest_night", "swamp_day", "swamp_night"},
    sounds = {{name = "ambient_sounds_wooden_frog", gain = 0.2}},
    min_interval = 60,
    max_interval = 120,
    chance = 0.5,
    distance = 50,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_mushroom_flute",
    environments = {"mushroom_day", "mushroom_night"},
    sounds = {
        {name = "ambient_sounds_flute", gain = 0.03},
        {name = "ambient_sounds_flute_2", gain = 0.25},
    },
    min_interval = 60,
    max_interval = 180,
    chance = 0.5,
    distance = 40,
})

ambient_sounds.register_random_sound({
    name = "ambient_sounds_frost_random_sounds",
    environments = {"frost_day", "frost_night"},
    sounds = {
        {name = "ambient_sounds_ethereal_crystal_2", gain = 0.03},
        {name = "ambient_sounds_ethereal_crystal_3", gain = 4},
    },
    min_interval = 30,
    max_interval = 100,
    chance = 0.4,
    distance = 60,
})
