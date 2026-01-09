--- Environment registrations

-- Icesheet day
ambient_sounds.register_environment("icesheet_day", {
    biomes = {"icesheet"},
    sounds = {
        {
            name = "ambient_sounds_howling_wind",
            gain = 0.3,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Icesheet night
ambient_sounds.register_environment("icesheet_night", {
    biomes = {"icesheet"},
    sounds = {
        {
            name = "ambient_sounds_howling_wind",
            gain = 0.3,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Tundra day
ambient_sounds.register_environment("tundra_day", {
    biomes = {"tundra"},
    sounds = {
        {
            name = "ambient_sounds_snowy_biomes_main_1",
            gain = 0.4,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Tundra night
ambient_sounds.register_environment("tundra_night", {
    biomes = {"tundra"},
    sounds = {
        {
            name = "ambient_sounds_howling_wind",
            gain = 0.3,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Taiga day
ambient_sounds.register_environment("taiga_day", {
    biomes = {"taiga"},
    sounds = {
        {
            name = "ambient_sounds_howling_wind",
            gain = 0.2,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Taiga night
ambient_sounds.register_environment("taiga_night", {
    biomes = {"taiga"},
    sounds = {
        {
            name = "ambient_sounds_howling_wind",
            gain = 0.3,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Snowy grassland day
ambient_sounds.register_environment("snowy_day", {
    biomes = {"snowy_grassland"},
    sounds = {
        {
            name = "ambient_sounds_snowy_biomes_main_1",
            gain = 0.4,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Snowy grassland night
ambient_sounds.register_environment("snowy_night", {
    biomes = {"snowy_grassland"},
    sounds = {
        {
            name = "ambient_sounds_howling_wind",
            gain = 0.3,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Grassland day
ambient_sounds.register_environment("plains_day", {
    biomes = {"grassland"},
    sounds = {
        {
            name = "ambient_sounds_ethereal_prairie_main",
            gain = 0.5,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Grassland night
ambient_sounds.register_environment("plains_night", {
    biomes = {"grassland"},
    sounds = {
        {
            name = "ambient_sounds_night_main_3",
            gain = 0.15,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Coniferous forest day
ambient_sounds.register_environment("coniferous_forest_day", {
    biomes = {"coniferous_forest"},
    sounds = {
        {
            name = "ambient_sounds_snowy_biomes_main_1",
            gain = 0.4,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Coniferous forest night
ambient_sounds.register_environment("coniferous_forest_night", {
    biomes = {"coniferous_forest"},
    sounds = {
        {
            name = "ambient_sounds_howling_wind",
            gain = 0.3,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Deciduous forest day
ambient_sounds.register_environment("deciduous_forest_day", {
    biomes = {"deciduous_forest"},
    sounds = {
        {
            name = "ambient_sounds_ethereal_prairie_main",
            gain = 0.5,
        },
        {
            name = "ambient_sounds_leaves_wind",
            gain = 0.05,
        }
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Deciduous forest night
ambient_sounds.register_environment("deciduous_forest_night", {
    biomes = {"deciduous_forest"},
    sounds = {
        {
            name = "ambient_sounds_night_main_3",
            gain = 0.15,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Desert day
ambient_sounds.register_environment("desert_day", {
    biomes = {"desert", "sandstone_desert", "cold_desert"},
    sounds = {
        {
            name = "ambient_sounds_cicadas_desert_1",
            pitch = 0.9,
            gain = 0.35,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Desert night
ambient_sounds.register_environment("desert_night", {
    biomes = {"desert", "sandstone_desert", "cold_desert"},
    sounds = {
        {
            name = "ambient_sounds_cicadas_desert_1",
            pitch = 0.9,
            gain = 0.35,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Savanna day
ambient_sounds.register_environment("savanna_day", {
    biomes = {"savanna"},
    sounds = {
        {
            name = "ambient_sounds_cicadas_desert_1",
            pitch = 0.9,
            gain = 0.35,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Savanna night
ambient_sounds.register_environment("savanna_night", {
    biomes = {"savanna"},
    sounds = {
        {
            name = "ambient_sounds_savanna_main_night",
            gain = 0.15,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday < 0.25 or tdef.timeofday > 0.75
    end,
    priority = 1,
})

-- Rainforest day
ambient_sounds.register_environment("rainforest_day", {
    biomes = {"rainforest"},
    sounds = {
        {
            name = "ambient_sounds_jungle_main",
            gain = 0.3,
        },
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})

-- Rainforest night
ambient_sounds.register_environment("rainforest_night", {
    biomes = {"rainforest"},
    sounds = {
        {
            name = "ambient_sounds_jungle_main_night",
            gain = 0.3,
        },
    },
    env_check = function(tdef)
        return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
            or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
    end,
    priority = 1,
})

-- Ocean day
ambient_sounds.register_environment("ocean_day", {
    biomes = {},
    sounds = {
        {
            name = "ambient_sounds_beach_1",
            gain = 0.25,
        },
    },
    env_check = function(tdef)
        local biome_name = tdef.biome

        -- Check if it's day
        if tdef.timeofday < 0.25 or tdef.timeofday > 0.75 then
            return false
        end

        if string.find(biome_name, "ocean", 1, true) then
            return true
        end

        local water_count = (tdef.totals["default:water_source"] or 0) +
                            (tdef.totals["default:water_flowing"] or 0)
        return water_count > ambient_sounds.config.ocean_water_count
    end,
    nodes = {"default:water_source", "default:water_flowing"},
    priority = 2,
})

-- Ocean night
ambient_sounds.register_environment("ocean_night", {
    biomes = {},
    sounds = {
        {
            name = "ambient_sounds_beach_1",
            gain = 0.25,
        },
    },
    env_check = function(tdef)
        local biome_name = tdef.biome

        -- Check if it's night
        if tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75 then
            return false
        end

        if string.find(biome_name, "ocean", 1, true) then
            return true
        end

        local water_count = (tdef.totals["default:water_source"] or 0) +
                            (tdef.totals["default:water_flowing"] or 0)
        return water_count > ambient_sounds.config.ocean_water_count
    end,
    nodes = {"default:water_source", "default:water_flowing"},
    priority = 2,
})

-- Cave
ambient_sounds.register_environment("cave", {
    y_max = -10,
    sounds = {
        {
            name = "ambient_sounds_cave_1",
            gain = 0.5,
        },
        {
            name = "ambient_sounds_cave_2",
            gain = 0.4,
        },
        {
            name = "ambient_sounds_cave_3",
            gain = 0.5,
        },
        {
            name = "ambient_sounds_cave_large_2",
            gain = 0.25,
        },
    },
    priority = 3,
})

-- Default
ambient_sounds.register_environment("default", {
    biomes = {},
    sounds = {
        {
            name = "ambient_sounds_ethereal_prairie_main",
            gain = 0.3,
        },
    },
    priority = 0,
})

--- Subenvironment registrations

-- Pond night
ambient_sounds.register_subenvironment("pond_night", {
    environments = {"deciduous_forest_night", "plains_night"},
    subenv_check = function(tdef)
        local pos = tdef.pos
        local radius = ambient_sounds.config.detection_radius
        
        -- Check if it's night
        if tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75 then
            return false
        end
        
        local water_count = (tdef.totals["default:water_source"] or 0) +
                            (tdef.totals["default:water_flowing"] or 0)
        return water_count > 30
    end,
    nodes = {"default:water_source", "default:water_flowing"},
    sounds = {
        {
            name = "ambient_sounds_frogs",
            gain = 0.1,
            pitch = 0.9,
        },
    },
    priority = 1,
})

--- Random sounds registrations

-- Wolf howl
local wolf_environments = {
    "deciduous_forest_night",
    "taiga_night", 
    "tundra_night",
    "coniferous_forest_night",
}

if core.get_modpath("ethereal") then
    table.insert(wolf_environments, "snowy_night")
end

ambient_sounds.register_random_sound({
    environments = wolf_environments,
    name = "ambient_sounds_wolf_howl",
    sounds = {
        {name = "ambient_sounds_wolf_1", gain = 0.6},
    },
    min_interval = 60,
    max_interval = 120,
    chance = 0.3,
    distance = 50,
})

-- Coyote
local coyote_environments = {
    "taiga_night",
    "taiga_day",
    "coniferous_forest_night",
    "coniferous_forest_day",
}

-- Add snowy biomes if ethereal mod is found
if core.get_modpath("ethereal") then
    table.insert(coyote_environments, "snowy_day")
    table.insert(coyote_environments, "snowy_night")
end

ambient_sounds.register_random_sound({
    name = "ambient_sounds_coyote",
    environments = coyote_environments,
    sounds = {
        {name = "ambient_sounds_coyote", gain = 0.5},
    },
    min_interval = 30,
    max_interval = 120,
    distance = 20,
    chance = 0.4,
})

-- Owl hoot
local owl_environments = {
    "deciduous_forest_night", 
    "taiga_day", "taiga_night", 
    "tundra_day", "tundra_night",
    "coniferous_forest_night",
    "plains_night",
}

if core.get_modpath("ethereal") then
    table.insert(owl_environments, "snowy_night")
end

ambient_sounds.register_random_sound({
    name = "ambient_sounds_owl_hoot",
    environments = owl_environments,
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

-- Eagle owl
ambient_sounds.register_random_sound({
    name = "ambient_sounds_eagle_owl",
    environments = {
        "taiga_night", 
        "tundra_night",
    },
    sounds = {
        {name = "ambient_sounds_eagle_owl", gain = 0.08},
    },
    min_interval = 60,
    max_interval = 120,
    distance = 50,
    chance = 0.25,
})

-- Crow
ambient_sounds.register_random_sound({
    name = "ambient_sounds_crow",
    environments = {
        "deciduous_forest_day", 
        "plains_day",
        "grove_day", -- ethereal
        "grayness_day", -- ethereal,
        "grassytwo_day", -- ethereal,
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
    distance = 50
})

-- Forest birds
ambient_sounds.register_random_sound({
    name = "ambient_sounds_forest_birds",
    environments = {
        "deciduous_forest_day",
        "plains_day",
        "bamboo_day", -- ethereal
        "grove_day", -- ethereal
        "grassytwo_day", -- ethereal,
        "prairie_day", -- ethereal
    },
    sounds = {
        {name = "ambient_sounds_cardinal", gain = 0.92},
        {name = "ambient_sounds_crestedlark", gain = 0.8},
        {name = "ambient_sounds_robin", gain = 0.8},
    },
    min_interval = 25,
    max_interval = 120,
    chance = 0.45,
    distance = 20
})

-- Canadian loon
ambient_sounds.register_random_sound({
    name = "ambient_sounds_canadian_loon",
    environments = {
        "rainforest_day", "rainforest_night",
        "swamp_day", "swamp_night" -- ethereal
    },
    sounds = {
        {name = "ambient_sounds_canadian_loon", gain = 0.5},
    },
    min_interval = 60,
    max_interval = 120,
    chance = 0.4,
    distance = 50,
})

-- Bambo flute
ambient_sounds.register_random_sound({
    name = "ambient_sounds_bamboo_flute",
    environments = {
        "rainforest_day", "rainforest_night",
        "bamboo_day", "bamboo_night", -- ethereal,
        "swamp_day", "swamp_night", -- ethereal
    },
    sounds = {
        {name = "ambient_sounds_flute_3", gain = 0.02},
    },
    min_interval = 120,
    max_interval = 240,
    chance = 0.3,
    distance = 55,
})

-- Seagull
ambient_sounds.register_random_sound({
    name = "ambient_sounds_seagull",
    environments = {
        "ocean_day",
        "icesheet_day",
        "grove_day" -- ethereal
    },
    sounds = {
        {name = "ambient_sounds_seagull", gain = 0.5},
        {name = "ambient_sounds_seagull_2", gain = 0.15},
    },
    min_interval = 60,
    max_interval = 120,
    chance = 0.5,
    distance = 70,
})

-- Peacock
ambient_sounds.register_random_sound({
    name = "ambient_sounds_peacock",
    environments = {
        "savanna_day",
        "rainforest_day",
        "bamboo_day", -- ethereal
        "mesa_day" -- ethereal
    },
    sounds = {
        {name = "ambient_sounds_peacock_1", gain = 0.85},
        {name = "ambient_sounds_peacock_2", gain = 0.015},
    },
    min_interval = 45,
    max_interval = 120,
    chance = 0.3,
    distance = 20,
})

-- Wooden frog
ambient_sounds.register_random_sound({
    name = "ambient_sounds_wooden_frog",
    environments = {
        "rainforest_day", "rainforest_night",
    },
    sounds = {
        {name = "ambient_sounds_wooden_frog", gain = 0.2},
    },
    min_interval = 60,
    max_interval = 120,
    chance = 0.5,
    distance = 50,
})

-- Ethereal support
if core.get_modpath("ethereal") then
    -- Bamboo day
    ambient_sounds.register_environment("bamboo_day", {
        biomes = {"bamboo"},
        sounds = {
            {
                name = "ambient_sounds_ethereal_prairie_main",
                gain = 0.5,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Bamboo night
    ambient_sounds.register_environment("bamboo_night", {
        biomes = {"bamboo"},
        sounds = {
            {
                name = "ambient_sounds_night_main_3",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Grassytwo day
    ambient_sounds.register_environment("grassytwo_day", {
        biomes = {"grassytwo"},
        sounds = {
            {
                name = "ambient_sounds_ethereal_prairie_main",
                gain = 0.5,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Grassytwo night
    ambient_sounds.register_environment("grassytwo_night", {
        biomes = {"grassytwo"},
        sounds = {
            {
                name = "ambient_sounds_night_main_3",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Prairie day
    ambient_sounds.register_environment("prairie_day", {
        biomes = {"prairie"},
        sounds = {
            {
                name = "ambient_sounds_ethereal_prairie_main",
                gain = 0.5,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Prairie night
    ambient_sounds.register_environment("prairie_night", {
        biomes = {"prairie"},
        sounds = {
            {
                name = "ambient_sounds_night_main_3",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Grove, jumble, mediterranean day
    ambient_sounds.register_environment("grove_day", {
        biomes = {"grove", "jumble", "mediterranean"},
        sounds = {
            {
                name = "ambient_sounds_ethereal_prairie_main",
                gain = 0.5,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Grove, jumble, mediterranean night
    ambient_sounds.register_environment("grove_night", {
        biomes = {"grove", "jumble", "mediterranean"},
        sounds = {
            {
                name = "ambient_sounds_night_main_3",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Mesa day (mesa, mesa_redwood, mesa_beach)
    ambient_sounds.register_environment("mesa_day", {
        biomes = {"mesa", "mesa_redwood", "mesa_beach"},
        sounds = {
            {
                name = "ambient_sounds_cicadas_desert_1",
                pitch = 0.9,
                gain = 0.35,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Mesa night (mesa, mesa_redwood, mesa_beach)
    ambient_sounds.register_environment("mesa_night", {
        biomes = {"mesa", "mesa_redwood", "mesa_beach"},
        sounds = {
            {
                name = "ambient_sounds_savanna_main_night",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday < 0.25 or tdef.timeofday > 0.75
        end,
        priority = 1,
    })

    -- Mushroom day
    ambient_sounds.register_environment("mushroom_day", {
        biomes = {"mushroom"},
        sounds = {
            {
                name = "ambient_sounds_jungle_main",
                gain = 0.3,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Mushroom night
    ambient_sounds.register_environment("mushroom_night", {
        biomes = {"mushroom"},
        sounds = {
            {
                name = "ambient_sounds_night_main_3",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Grayness day
    ambient_sounds.register_environment("grayness_day", {
        biomes = {"grayness"},
        sounds = {
            {
                name = "ambient_sounds_leaves_wind",
                gain = 0.04,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Grayness night
    ambient_sounds.register_environment("grayness_night", {
        biomes = {"grayness"},
        sounds = {
            {
                name = "ambient_sounds_night_main_3",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Frost
    ambient_sounds.register_environment("frost_day", {
        biomes = {"frost"},
        sounds = {
            {
                name = "ambient_sounds_howling_wind",
                gain = 0.2,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Frost night
    ambient_sounds.register_environment("frost_night", {
        biomes = {"frost"},
        sounds = {
            {
                name = "ambient_sounds_night_main_3",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Fiery day
    ambient_sounds.register_environment("fiery_day", {
        biomes = {"fiery"},
        sounds = {
            {name = "ambient_sounds_ethereal_fiery_main", gain = 0.08},
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Fiery night
    ambient_sounds.register_environment("fiery_night", {
        biomes = {"fiery"},
        sounds = {
            {name = "ambient_sounds_ethereal_fiery_main", gain = 0.08},
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Ethereal plains day
    ambient_sounds.register_environment("ethereal_plains_day", {
        biomes = {"plains"},
        sounds = {
            {
                name = "ambient_sounds_snowy_biomes_main_1",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Ethereal plains night
    ambient_sounds.register_environment("ethereal_plains_night", {
        biomes = {"plains"},
        sounds = {
            {
                name = "ambient_sounds_savanna_main_night",
                gain = 0.15,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday < 0.25 or tdef.timeofday > 0.75
        end,
        priority = 1,
    })

    -- Swamp, mangrove day
    ambient_sounds.register_environment("swamp_day", {
        biomes = {"rainforest"},
        sounds = {
            {
                name = "ambient_sounds_jungle_main",
                gain = 0.3,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Swamp, mangrove night
    ambient_sounds.register_environment("swamp_night", {
        biomes = {"swamp", "mangrove"},
        sounds = {
            {
                name = "ambient_sounds_jungle_main_night",
                gain = 0.3,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Mountain day
    ambient_sounds.register_environment("mountain_day", {
        biomes = {"mountain"},
        sounds = {
            {name = "ambient_sounds_howling_wind", gain = 0.2},
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Mountain night
    ambient_sounds.register_environment("mountain_night", {
        biomes = {"mountain"},
        sounds = {
            {name = "ambient_sounds_howling_wind", gain = 0.3},
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Caves day
    ambient_sounds.register_environment("caves_day", {
        biomes = {"caves"},
        sounds = {
            {
                name = "ambient_sounds_cicadas_desert_1",
                pitch = 0.9,
                gain = 0.35,
            },
        },
        env_check = function(tdef)
            return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
        end,
        priority = 1,
    })

    -- Caves night
    ambient_sounds.register_environment("caves_night", {
        biomes = {"caves"},
        sounds = {
            {
                name = "ambient_sounds_cicadas_desert_1",
                pitch = 0.9,
                gain = 0.35,
            },
        },
        env_check = function(tdef)
            return (tdef.timeofday >= 0 and tdef.timeofday <= 0.25)
                or (tdef.timeofday >= 0.75 and tdef.timeofday <= 1.0)
        end,
        priority = 1,
    })

    -- Flute (mushroom biome)
    ambient_sounds.register_random_sound({
        name = "ambient_sounds_mushroom_flute",
        environments = {
            "mushroom_day", "mushroom_night",
        },
        sounds = {
            {name = "ambient_sounds_flute", gain = 0.03},
            {name = "ambient_sounds_flute_2", gain = 0.25},
        },
        min_interval = 60,
        max_interval = 180,
        chance = 0.5,
        distance = 40,
    })

    -- Frost random sounds
    ambient_sounds.register_random_sound({
        name = "ambient_sounds_frost_random_sounds",
        environments = {
            "frost_day", "frost_night",
        },
        sounds = {
            {name = "ambient_sounds_ethereal_crystal_2", gain = 0.03},
            {name = "ambient_sounds_ethereal_crystal_3", gain = 4},
        },
        min_interval = 30,
        max_interval = 100,
        chance = 0.4,
        distance = 60,
    })
end