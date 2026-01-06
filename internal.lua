-- Active sounds for each player
ambient_sounds.active_sounds = {}

-- Environments
ambient_sounds.environments = {}

-- Subenvironments (structures, rivers, etc. that can appear within environments)
ambient_sounds.subenvironments = {}

-- Random sounds definitions
ambient_sounds.environment_random_sounds = {}

-- Random sounds timers
ambient_sounds.random_sounds_timers = {}

-- Nodes to check
ambient_sounds.nodes_to_check = {}

-- Debug log
function ambient_sounds.debug(message)
    if ambient_sounds.config.debug_mode then
        core.log("debug", "[Ambient Sounds] " .. message)
    end
end

-- Check if environment matches current conditions
local function check_environment_match(env_def, check_def)
    local biome_name = check_def.biome
    local pos = check_def.pos
    local timeofday = check_def.timeofday
    
    -- Check biome match
    if env_def.biomes and #env_def.biomes > 0 then
        local biome_match = false
        for _, biome in ipairs(env_def.biomes) do
            -- Pattern match fallback
            if biome_name == biome or string.find(biome_name, biome, 1, true) then
                biome_match = true
                break
            end
        end
        if not biome_match then
            return false
        end
    end
    
    -- Check Y
    if env_def.y_min and pos.y < env_def.y_min then
        return false
    end
    if env_def.y_max and pos.y > env_def.y_max then
        return false
    end
    
    -- Check custom function
    if env_def.env_check then
        local result = env_def.env_check(check_def)
        if not result or result == false then
            return false
        end
    end
    
    return true
end

-- Get matching environment for current conditions
local function get_matching_environment(check_def)
    local best_env = nil
    local best_priority = -1
    
    for env_name, env_def in pairs(ambient_sounds.environments) do
        if check_environment_match(env_def, check_def) then
            if env_def.priority > best_priority then
                best_priority = env_def.priority
                best_env = {name = env_name, def = env_def}
            end
        end
    end
    
    return best_env
end

-- Get random sound from environment's sounds array
local function get_random_environment_sound(env_def)
    if not env_def.sounds or #env_def.sounds == 0 then
        return nil
    end
    
    -- Select random sound from array
    local sound_index = math.random(1, #env_def.sounds)
    local sound_template = env_def.sounds[sound_index]
    
    local sound_name = sound_template.name
    
    return {
        name = sound_name,
        gain = sound_template.gain,
        priority = env_def.priority,
        pitch = sound_template.pitch,
        fade_in = sound_template.fade_in,
        fade_out = sound_template.fade_out,
    }
end

local function subenvironment_applies_to(subenv_def, environment_name)
    -- If no environment list specified, applies to all environments
    if not subenv_def.environments then
        return true
    end
    
    -- Check if environment is in the allowed list
    for _, env_name in ipairs(subenv_def.environments) do
        if env_name == environment_name then
            return true
        end
    end
    
    return false
end

-- Check subenvironments for current environment
local function get_matching_subenvironments(environment_name, check_def)
    local found_subenvs = {}
    
    for subenv_name, subenv_def in pairs(ambient_sounds.subenvironments) do
        if subenvironment_applies_to(subenv_def, environment_name) then
            local check_result = subenv_def.subenv_check(check_def)
            if check_result then
                table.insert(found_subenvs, {
                    name = subenv_name,
                    def = subenv_def,
                })
            end
        end
    end
    
    return found_subenvs
end

-- Stop sound
function ambient_sounds.stop_sound(player_name, sound_key)
    local player_sounds = ambient_sounds.active_sounds[player_name]
    if not player_sounds then
        ambient_sounds.debug("stop_sound: no player sounds for " .. tostring(player_name))
        return
    end

    local sound_data = player_sounds[sound_key]
    if not sound_data or not sound_data.handle then
        ambient_sounds.debug("stop_sound: no sound data or handle for " .. tostring(sound_key))
        return
    end

    ambient_sounds.debug("Stopping sound: " .. tostring(sound_key) .. " for player " .. tostring(player_name))
    -- Gain per second to reach zero
    local current_gain = sound_data.sound_def and sound_data.sound_def.gain or ambient_sounds.config.gain
    local fade_step = current_gain / (sound_data.sound_def and sound_data.sound_def.fade_in or ambient_sounds.config.fade_time)
    
    core.sound_fade(sound_data.handle, fade_step, 0.0)
    player_sounds[sound_key] = nil
end

-- Play sound
function ambient_sounds.play_sound(player_name, sound_key, sound_def, pos)
    if not sound_def then
        core.log("error", "[Ambient Sounds] play_sound: sound_def is nil for key=" .. tostring(sound_key))
        return
    end
    if not sound_def.name then
        core.log("error", "[Ambient Sounds] play_sound: sound_def.name is nil for key=" .. tostring(sound_key))
        return
    end

    ambient_sounds.debug("play_sound called: player=" .. tostring(player_name) .. 
        ", key=" .. tostring(sound_key) .. ", sound_name=" .. tostring(sound_def.name) ..
        ", priority=" .. tostring(sound_def.priority) .. ", gain=" .. tostring(sound_def.gain))

    local player_sounds = ambient_sounds.active_sounds[player_name]
    if not player_sounds then
        ambient_sounds.active_sounds[player_name] = {}
        player_sounds = ambient_sounds.active_sounds[player_name]
        ambient_sounds.debug("Created new sound table for player: " .. tostring(player_name))
    end

    -- Check if the sound is already playing
    -- Update the sound if the sound name has changed
    -- if player_sounds[sound_key] and player_sounds[sound_key].handle then
    --     local existing_sound = player_sounds[sound_key]
    --     local existing_name = existing_sound.sound_def and existing_sound.sound_def.name
    --     if existing_name == sound_def.name then
    --         ambient_sounds.debug("Sound already playing: " .. tostring(sound_key) .. 
    --             " for player " .. tostring(player_name))
    --         return
    --     else
    --         -- Stop the old sound
    --         ambient_sounds.stop_sound(player_name, sound_key)
    --     end
    -- end
    if player_sounds[sound_key] then
        local existing_sound = player_sounds[sound_key]
        local existing_name = existing_sound.sound_def and existing_sound.sound_def.name
        ambient_sounds.debug("Environment sound already playing: key=" .. tostring(sound_key)
                .. " variant=" .. tostring(existing_name)
                .. " for player " .. tostring(player_name))
        return
    end

    -- Stop sounds with lower priority
    for key, existing_sound in pairs(player_sounds) do
        if existing_sound.priority and existing_sound.priority < sound_def.priority then
            local existing_name = existing_sound.sound_def and existing_sound.sound_def.name
            ambient_sounds.debug("Stopping lower priority sound:  key=" .. tostring(key) ..
                ", name=" .. tostring(existing_name) ..
                ", priority=" .. tostring(existing_sound.priority) ..
                " for player " .. tostring(player_name))
            ambient_sounds.stop_sound(player_name, key)
        end
    end

    -- Play the new sound
    local sound_spec = {
        name = sound_def.name,
        gain = sound_def.gain or ambient_sounds.config.gain,
        fade = sound_def.gain / (sound_def.fade_in or ambient_sounds.config.fade_time),
        pitch = sound_def.pitch or 1.0,
    }

    local sound_params = {
        to_player = player_name,
        loop = true,
    }

    ambient_sounds.debug("Playing sound: name=" .. tostring(sound_spec.name) .. 
        ", gain=" .. tostring(sound_spec.gain) .. ", fade=" .. tostring(sound_spec.fade) ..
        " for player " .. tostring(player_name))
    
    local handle = core.sound_play(sound_spec, sound_params)

    if handle then
        ambient_sounds.debug("Sound handle returned: " .. tostring(handle) .. " for " .. tostring(sound_key))
        player_sounds[sound_key] = {
            handle = handle,
            priority = sound_def.priority,
            sound_def = sound_def,
        }
    else
        core.log("error", "[Ambient Sounds] Sound handle is nil! Sound may not be playing. " ..
            "sound_name=" .. tostring(sound_spec.name) .. ", player=" .. tostring(player_name) ..
            ". Check if sound file exists: " .. tostring(sound_def.name))
    end
end

-- Simple elapsed time counter
ambient_sounds.start_time = 0
function ambient_sounds.get_current_time()
    return ambient_sounds.start_time
end

function ambient_sounds.update_current_time(dtime)
    ambient_sounds.start_time = ambient_sounds.start_time + dtime
end

-- Play random sound
function ambient_sounds.play_random_sound(player_name, environment_name, pos)
    if not environment_name then
        return
    end

    if not ambient_sounds.random_sounds_timers[player_name] then
        ambient_sounds.random_sounds_timers[player_name] = {}
    end
    
    local timers = ambient_sounds.random_sounds_timers[player_name]
    local current_time = ambient_sounds.get_current_time()

    -- Check all random sounds
    for _, random_sound_def in ipairs(ambient_sounds.environment_random_sounds) do
        -- Check if random sound can play in the current environment
        local can_play = false
        for _, env_name in ipairs(random_sound_def.environments) do
            if env_name == environment_name then
                can_play = true
                break
            end
        end
        
        if not can_play then
            goto continue
        end

        -- Random sound timer
        local sound_key = random_sound_def.name
        local timer_data = timers[sound_key]
        local last_played = 0
        local next_interval = nil
        
        if timer_data then
            last_played = timer_data.last_played or 0
            next_interval = timer_data.next_interval
        end
        
        local interval = next_interval
        if not interval then
            interval = math.random(random_sound_def.min_interval, random_sound_def.max_interval)
        end

        -- Check if enough time has passed
        if (current_time - last_played) >= interval then
            if math.random() < random_sound_def.chance then
                -- Select a random sound
                local sound_index = math.random(1, #random_sound_def.sounds)
                local sound_template = random_sound_def.sounds[sound_index]
                
                -- Generate a random position for the sound source around the player
                local sound_pos = {
                    x = pos.x + (math.random() - 0.5) * random_sound_def.distance * 2,
                    y = pos.y + (math.random() - 0.5) * random_sound_def.distance * 0.5,
                    z = pos.z + (math.random() - 0.5) * random_sound_def.distance * 2,
                }

                local sound_spec = {
                    name = sound_template.name,
                    gain = sound_template.gain or ambient_sounds.config.gain,
                    pitch = sound_template.pitch or 1.0,
                }
                
                local sound_params = {
                    to_player = player_name,
                    pos = sound_pos,
                    loop = false,
                }

                ambient_sounds.debug("Playing random sound: name=" .. tostring(sound_spec.name) .. 
                    ", gain=" .. tostring(sound_spec.gain) .. ", pos=".. core.pos_to_string(sound_pos) ..
                    ", for player " .. tostring(player_name))
                ambient_sounds.debug("Details " ..
                    ", environment=" .. tostring(environment_name) ..
                    ", time_elapsed=" .. tostring(current_time - last_played))
                core.sound_play(sound_spec, sound_params, true)

                -- New interval
                local new_interval = math.random(random_sound_def.min_interval, random_sound_def.max_interval)
                timers[sound_key] = {
                    last_played = current_time,
                    next_interval = new_interval,
                }

                -- Play only one sound per call
                return
            else
                -- Reduce timer so sounds eventually play
                local cooldown = interval * 0.3  -- 30% of actual interval
                timers[sound_key] = {
                    last_played = current_time - interval + cooldown,
                    next_interval = interval,
                }
            end
        end
        
        ::continue::
    end
end

-- Update sounds for a player
function ambient_sounds.update_player_sounds(player_name)
    local player = core.get_player_by_name(player_name)
    if not player then
        if ambient_sounds.active_sounds[player_name] then
            ambient_sounds.active_sounds[player_name] = nil
        end
        return
    end

    local pos = player:get_pos()
    if not pos then return end

    local node_pos = vector.round(pos)

    local biome_data = core.get_biome_data(node_pos)
    local biome_name = biome_data and core.get_biome_name(biome_data.biome) or "default"

    local timeofday = core.get_timeofday()

    -- Pre-compute node positions and totals for optimization
    local radius = ambient_sounds.config.detection_radius
    local min_pos = {
        x = node_pos.x - radius,
        y = node_pos.y - radius,
        z = node_pos.z - radius
    }
    local max_pos = {
        x = node_pos.x + radius,
        y = node_pos.y + radius,
        z = node_pos.z + radius
    }
    
    -- Find nodes from list
    local positions, totals = core.find_nodes_in_area(min_pos, max_pos, ambient_sounds.nodes_to_check)
    
    -- Create check def table to pass to check functions
    local check_def = {
        player = player,
        pos = pos,
        timeofday = timeofday,
        totals = totals,
        positions = positions,
        biome = biome_name,
    }

    -- Find matching environment
    local matching_env = get_matching_environment(check_def)
    
    local sounds_to_play = {}
    local current_environment_name = nil

    if matching_env then
        current_environment_name = matching_env.name
        ambient_sounds.debug("Player " .. tostring(player_name) .. 
            " at pos (" .. tostring(node_pos.x) .. "," .. tostring(node_pos.y) .. "," .. tostring(node_pos.z) .. 
            "), biome=" .. tostring(biome_name) .. ", environment=" .. tostring(current_environment_name))
        
        -- Get random sound from environment's sounds array
        if matching_env.def.sounds and #matching_env.def.sounds > 0 then
            local env_sound = get_random_environment_sound(matching_env.def)
            if env_sound then
                local sound_key = current_environment_name
                table.insert(sounds_to_play, {
                    key = sound_key,
                    sound = env_sound,
                })
                ambient_sounds.debug("Selected random sound from environment: " .. 
                    tostring(env_sound.name) .. " (gain=" .. tostring(env_sound.gain) .. ")")
            end
        end
        
        -- Check for subenvironments within this environment
        local subenvs = get_matching_subenvironments(current_environment_name, check_def)
        
        for _, subenv in ipairs(subenvs) do
            ambient_sounds.debug("Found subenvironment: " .. tostring(subenv.name) .. 
                " in environment: " .. tostring(current_environment_name))
            
            -- Get random sound from subenvironment's sounds array
            if subenv.def.sounds and #subenv.def.sounds > 0 then
                local subenv_sound_template = subenv.def.sounds[math.random(1, #subenv.def.sounds)]
                local subenv_sound_name = subenv_sound_template.name
                
                local subenv_gain = subenv_sound_template.gain or subenv.def.gain or ambient_sounds.config.gain
                
                local sound_key = subenv.name
                table.insert(sounds_to_play, {
                    key = sound_key,
                    sound = {
                        name = subenv_sound_name,
                        gain = subenv_gain,
                        priority = subenv.def.priority,
                        pitch = subenv_sound_template.pitch,
                        fade_in = subenv_sound_template.fade_in,
                        fade_out = subenv_sound_template.fade_out,
                    },
                })
                ambient_sounds.debug("Added subenvironment sound: " .. tostring(subenv.name) .. 
                    " -> " .. tostring(subenv_sound_name))
            end
        end
    end

    local active_keys = {}
    for _, sound_data in ipairs(sounds_to_play) do
        active_keys[sound_data.key] = true
    end

    local active_keys_str = ""
    for k, _ in pairs(active_keys) do
        active_keys_str = active_keys_str .. k .. " "
    end
    ambient_sounds.debug("Active sound keys: {" .. active_keys_str .. "}")
    
    local player_sounds = ambient_sounds.active_sounds[player_name] or {}
    local current_sounds_str = ""
    for k, _ in pairs(player_sounds) do
        current_sounds_str = current_sounds_str .. k .. " "
    end
    ambient_sounds.debug("Current playing sounds: {" .. current_sounds_str .. "}")
    
    for sound_key, _ in pairs(player_sounds) do
        if not active_keys[sound_key] then
            ambient_sounds.debug("Sound '" .. tostring(sound_key) .. "' no longer needed, stopping")
            ambient_sounds.stop_sound(player_name, sound_key)
        else
            ambient_sounds.debug("Sound '" .. tostring(sound_key) .. "' should continue playing")
        end
    end
    
    -- Play new sounds
    ambient_sounds.debug("Sounds to play count: " .. tostring(#sounds_to_play) .. " for player " .. tostring(player_name))
    for _, sound_data in ipairs(sounds_to_play) do
        ambient_sounds.debug("Attempting to play sound: key=" .. tostring(sound_data.key) .. 
            ", name=" .. tostring(sound_data.sound.name))
        ambient_sounds.play_sound(
            player_name,
            sound_data.key,
            sound_data.sound,
            pos
        )
    end
    
    -- Play random sound
    if current_environment_name then
        ambient_sounds.play_random_sound(player_name, current_environment_name, pos)
    end
end