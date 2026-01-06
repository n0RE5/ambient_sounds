-- Register environment
-- @param name (string) Environment name (e.g., "forest", "cave", "mine")
-- @param tdef (table) Environment definition with fields:
--   - biomes (table, optional): List of biome names this environment applies to
--   - sounds (table, optional): Array of sounds to randomly play from
--      - name (string, required): Sound name
--      - gain (number, optional): Gain (default: 0.5)
--      - pitch (number, optional): Pitch (default: 1.0)
--      - fade_in (number, optional): Fade in time (default: 2)
--      - fade_out (number, optional): Fade out time (default: 2)
--   - priority (number, required): Priority level (higher = more important)
--   - y_min/y_max (number, optional): Y coordinate range
--   - nodes (table, optional): List of node names to check
--   - env_check (function, optional): Custom check function(tdef) -> boolean
--      tdef (table): Table with fields:
--        - player: player ref
--        - pos: player position
--        - timeofday: time of day
--        - totals: totals for each node e.g. tdef.totals["default:sand"]
--        - positions: position data for every node found
--        - biome: name of biome at current position
-- @example
--   ambient_sounds.register_environment("forest_day", {
--       biomes = {"deciduous_forest"},
--       sounds = {
--           {name = "ambient_sounds_forest_day", gain = 0.5},
--       },
--       env_check = function(tdef)
--           return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
--       end,
--       priority = 1,
--   })
function ambient_sounds.register_environment(name, tdef)
    if not name or type(name) ~= "string" then
        error("[Ambient Sounds] register_environment: name must be a string")
    end
    if not tdef or type(tdef) ~= "table" then
        error("[Ambient Sounds] register_environment: tdef must be a table")
    end
    if tdef.biomes and type(tdef.biomes) ~= "table" then
        error("[Ambient Sounds] register_environment: tdef.biomes must be a table")
    end
    if tdef.sounds and type(tdef.sounds) ~= "table" then
        error("[Ambient Sounds] register_environment: tdef.sounds must be a table")
    end
    if tdef.y_min and type(tdef.y_min) ~= "number" then
        error("[Ambient Sounds] register_environment: tdef.y_min must be a number")
    end
    if tdef.y_max and type(tdef.y_max) ~= "number" then
        error("[Ambient Sounds] register_environment: tdef.y_max must be a number")
    end
    if not tdef.priority or type(tdef.priority) ~= "number" then
        error("[Ambient Sounds] register_environment: tdef.priority must be a number")
    end
    if tdef.env_check and type(tdef.env_check) ~= "function" then
        error("[Ambient Sounds] register_environment: tdef.env_check must be a function")
    end
    if tdef.nodes and type(tdef.nodes) ~= "table" then
        error("[Ambient Sounds] register_environment: tdef.nodes must be a table")
    end

    -- Validate nodes array
    if tdef.nodes then
        for i, node in ipairs(tdef.nodes) do
            if not node or type(node) ~= "string" then
                error("[Ambient Sounds] register_environment: tdef.nodes[" .. i .. "] must be a string")
            end
        end
    end

    -- Validate sounds array
    if tdef.sounds then
        for i, sound in ipairs(tdef.sounds) do
            if not sound.name or type(sound.name) ~= "string" then
                error("[Ambient Sounds] register_environment: sounds[" .. i .. "].name must be a string")
            end
            if sound.gain and type(sound.gain) ~= "number" then
                error("[Ambient Sounds] register_environment: sounds[" .. i .. "].gain must be a number")
            end
            if sound.pitch and type(sound.pitch) ~= "number" then
                error("[Ambient Sounds] register_environment: sounds[" .. i .. "].pitch must be a number")
            end
            if sound.fade_in and type(sound.fade_in) ~= "number" then
                error("[Ambient Sounds] register_environment: sounds[" .. i .. "].fade_in must be a number")
            end
            if sound.fade_out and type(sound.fade_out) ~= "number" then
                error("[Ambient Sounds] register_environment: sounds[" .. i .. "].fade_out must be a number")
            end
        end
    end

    -- Validate biomes array
    if tdef.biomes then
        for i, biome in ipairs(tdef.biomes) do
            if not biome or type(biome) ~= "string" then
                error("[Ambient Sounds] register_environment: biomes[" .. i .. "] must be a string")
            end
        end
    end

    -- Set defaults
    tdef.sounds = tdef.sounds or {}
    tdef.biomes = tdef.biomes or {}

    -- Set nodes to check
    if tdef.nodes then
        local flag = true
        for i, node in ipairs(tdef.nodes) do
            for j, node_name in ipairs(ambient_sounds.nodes_to_check) do
                if node_name == node then
                    flag = false
                    break
                end
            end
            if flag then
                table.insert(ambient_sounds.nodes_to_check, node)
            end
        end
    end

    ambient_sounds.environments[name] = tdef
    core.log("action", "[Ambient Sounds] Registered environment: " .. name .. 
        " (priority=" .. tdef.priority .. ", sounds=" .. #tdef.sounds .. ", biomes=" .. #tdef.biomes .. ")")
end

-- Register subenvironment
-- @param name (string) Subenvironment name (e.g., "water", "river", "structure")
-- @param tdef (table) Subenvironment definition with fields:
--   - environments (table, optional): List of environment names this applies to (nil -> all)
--   - subenv_check (function, required): Function(tdef) -> boolean
--      tdef (table): Table with fields:
--        - player: player ref
--        - pos: player position
--        - timeofday: time of day
--        - totals: totals for each node e.g. tdef.totals["default:sand"]
--        - positions: position data for every node found
--        - biome: name of biome at current position
--   - sounds (table, optional): Array of sounds to randomly play from
--      - name (string, required): Sound name
--      - gain (number, optional): Gain (default: 0.5)
--      - pitch (number, optional): Pitch (default: 1.0)
--      - fade_in (number, optional): Fade in time (default: 2)
--      - fade_out (number, optional): Fade out time (default: 2)
--   - priority (number, optional): Priority level (default: 1)
--   - nodes (table, optional): List of node names to check
-- @example
--   ambient_sounds.register_subenvironment("water", {
--       environments = {"forest_day", "desert_day"},
--       subenv_check = function(tdef)
--           local water_count = (tdef.totals["default:water_source"] or 0) + 
--                              (tdef.totals["default:water_flowing"] or 0)
--           return water_count > 0
--       end,
--       nodes = {"default:water_source", "default:water_flowing"},
--       sounds = {
--           {name = "ambient_sounds_water_day", gain = 0.4},
--       },
--       priority = 1,
--   })
function ambient_sounds.register_subenvironment(name, tdef)
    if not name or type(name) ~= "string" then
        error("[Ambient Sounds] register_subenvironment: name must be a string")
    end
    if not tdef or type(tdef) ~= "table" then
        error("[Ambient Sounds] register_subenvironment: tdef must be a table")
    end
    if not tdef.subenv_check or type(tdef.subenv_check) ~= "function" then
        error("[Ambient Sounds] register_subenvironment: tdef.subenv_check must be a function")
    end
    if tdef.environments and type(tdef.environments) ~= "table" then
        error("[Ambient Sounds] register_subenvironment: tdef.environments must be a table")
    end
    if tdef.sounds and type(tdef.sounds) ~= "table" then
        error("[Ambient Sounds] register_subenvironment: tdef.sounds must be a table")
    end
    if tdef.priority and type(tdef.priority) ~= "number" then
        error("[Ambient Sounds] register_subenvironment: tdef.priority must be a number")
    end
    if tdef.nodes and type(tdef.nodes) ~= "table" then
        error("[Ambient Sounds] register_subenvironment: tdef.nodes must be a table")
    end

    -- Validate nodes array
    if tdef.nodes then
        for i, node in ipairs(tdef.nodes) do
            if not node or type(node) ~= "string" then
                error("[Ambient Sounds] register_subenvironment: tdef.nodes[" .. i .. "] must be a string")
            end
        end
    end

    -- Validate sounds array
    if tdef.sounds then
        for i, sound in ipairs(tdef.sounds) do
            if not sound.name or type(sound.name) ~= "string" then
                error("[Ambient Sounds] register_subenvironment: sounds[" .. i .. "].name must be a string")
            end
            if sound.gain and type(sound.gain) ~= "number" then
                error("[Ambient Sounds] register_subenvironment: sounds[" .. i .. "].gain must be a number")
            end
            if sound.pitch and type(sound.pitch) ~= "number" then
                error("[Ambient Sounds] register_subenvironment: sounds[" .. i .. "].pitch must be a number")
            end
            if sound.fade_in and type(sound.fade_in) ~= "number" then
                error("[Ambient Sounds] register_subenvironment: sounds[" .. i .. "].fade_in must be a number")
            end
            if sound.fade_out and type(sound.fade_out) ~= "number" then
                error("[Ambient Sounds] register_subenvironment: sounds[" .. i .. "].fade_out must be a number")
            end
        end
    end

    -- Validate environments array
    if tdef.environments then
        for i, env_name in ipairs(tdef.environments) do
            if not env_name or type(env_name) ~= "string" then
                error("[Ambient Sounds] register_subenvironment: environments[" .. i .. "] must be a string")
            end
        end
    end

    -- Set defaults
    tdef.sounds = tdef.sounds or {}
    tdef.environments = tdef.environments or nil  -- nil -> applies to all environments
    tdef.priority = tdef.priority or 1

    -- Set nodes to check
    if tdef.nodes then
        local flag = true
        for i, node in ipairs(tdef.nodes) do
            for j, node_name in ipairs(ambient_sounds.nodes_to_check) do
                if node_name == node then
                    flag = false
                    break
                end
            end
            if flag then
                table.insert(ambient_sounds.nodes_to_check, node)
            end
        end
    end
    
    ambient_sounds.subenvironments[name] = tdef
    core.log("action", "[Ambient Sounds] Registered subenvironment: " .. name .. 
        " (priority=" .. tdef.priority .. ", sounds=" .. #tdef.sounds .. 
        ", environments=" .. (tdef.environments and #tdef.environments or "all") .. ")")
end

-- Register random sound for environments
-- @param tdef (table) Random sound definition with fields:
--   - name (string, required): Unique identifier for this random sound
--   - environments (table, required): List of environment names (nil = all)
--   - sounds (table, required): Array of sound definitions with fields:
--     - name (string, required): Sound name
--     - gain (number, optional): Gain (default: uses tdef.gain or 0.5)
--     - pitch (number, optional): Pitch (default: 1.0)
--   - min_interval (number, optional): Min interval in seconds (default: 30)
--   - max_interval (number, optional): Max interval in seconds (default: 120)
--   - chance (number, optional): Probability 0.0-1.0 (default: 0.3)
--   - distance (number, optional): Distance from player in nodes (default: 50)
-- @example
--   ambient_sounds.register_random_sound({
--       name = "ambient_sounds_wolf_howl",
--       environments = {"forest_day", "forest_night"},
--       sounds = {
--           {name = "ambient_sounds_wolf_howl", gain = 0.6},
--       },
--       min_interval = 30,
--       max_interval = 120,
--       chance = 0.3,
--       distance = 50,
--   })
function ambient_sounds.register_random_sound(tdef)
    if not tdef or type(tdef) ~= "table" then
        error("[Ambient Sounds] register_random_sound: tdef must be a table")
    end
    if not tdef.name or type(tdef.name) ~= "string" then
        error("[Ambient Sounds] register_random_sound: tdef.name must be a string")
    end
    if not tdef.environments or type(tdef.environments) ~= "table" or #tdef.environments == 0 then
        error("[Ambient Sounds] register_random_sound: tdef.environments must be a non-empty table")
    end
    if not tdef.sounds or type(tdef.sounds) ~= "table" or #tdef.sounds == 0 then
        error("[Ambient Sounds] register_random_sound: tdef.sounds must be a non-empty table")
    end
    if tdef.min_interval and type(tdef.min_interval) ~= "number" then
        error("[Ambient Sounds] register_random_sound: tdef.min_interval must be a number")
    end
    if tdef.max_interval and type(tdef.max_interval) ~= "number" then
        error("[Ambient Sounds] register_random_sound: tdef.max_interval must be a number")
    end
    if tdef.chance and type(tdef.chance) ~= "number" then
        error("[Ambient Sounds] register_random_sound: tdef.chance must be a number")
    end
    if tdef.distance and type(tdef.distance) ~= "number" then
        error("[Ambient Sounds] register_random_sound: tdef.distance must be a number")
    end

    -- Validate environments array
    for i, environment_name in ipairs(tdef.environments) do
        if not environment_name or type(environment_name) ~= "string" then
            error("[Ambient Sounds] register_random_sound: tdef.environments[" .. i .. "] must be a string")
        end
    end

    -- Validate sounds array
    for i, sound in ipairs(tdef.sounds) do
        if not sound.name or type(sound.name) ~= "string" then
            error("[Ambient Sounds] register_random_sound: tdef.sounds[" .. i .. "].name must be a string")
        end
        if sound.gain and type(sound.gain) ~= "number" then
            error("[Ambient Sounds] register_random_sound: tdef.sounds[" .. i .. "].gain must be a number")
        end
        if sound.pitch and type(sound.pitch) ~= "number" then
            error("[Ambient Sounds] register_random_sound: tdef.sounds[" .. i .. "].pitch must be a number")
        end
    end

    -- Validate ranges
    if tdef.min_interval and tdef.max_interval and tdef.min_interval >= tdef.max_interval then
        error("[Ambient Sounds] register_random_sound: min_interval must be less than max_interval")
    end
    if tdef.chance and (tdef.chance < 0 or tdef.chance > 1) then
        error("[Ambient Sounds] register_random_sound: chance must be between 0 and 1")
    end

    -- Set defaults
    tdef.min_interval = tdef.min_interval or 30
    tdef.max_interval = tdef.max_interval or 120
    tdef.chance = tdef.chance or 0.3
    tdef.distance = tdef.distance or 50

    table.insert(ambient_sounds.environment_random_sounds, tdef)
    
    local env_list = table.concat(tdef.environments, ", ")
    core.log("action", "[Ambient Sounds] Registered random sound " .. tdef.name .. " for environments: " .. env_list .. 
        " (sounds: " .. #tdef.sounds .. ")")
end