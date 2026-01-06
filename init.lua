ambient_sounds = {}

dofile(core.get_modpath("ambient_sounds") .. "/settings.lua")

-- Configuration
ambient_sounds.config = {
    -- Enable debug logging
    debug_mode = ambient_sounds.debug_mode or false,
    -- Interval for checking the environment (in seconds)
    check_interval = ambient_sounds.check_interval or 2.0,
    -- Nodes detection radius
    detection_radius = ambient_sounds.detection_radius or 15,
    -- Time for fading in/out when switching sounds (in seconds)
    fade_time = ambient_sounds.fade_time or 2.0,
    -- Default gain
    gain = ambient_sounds.gain or 0.5,
    -- Ocean water count threshold
    ocean_water_count = ambient_sounds.ocean_water_count or 200,
}

dofile(core.get_modpath("ambient_sounds") .. "/api.lua")
dofile(core.get_modpath("ambient_sounds") .. "/internal.lua")
dofile(core.get_modpath("ambient_sounds") .. "/registrations.lua")
dofile(core.get_modpath("ambient_sounds") .. "/external_environments.lua")

-- Global step
local last_check_time = 0
core.register_globalstep(function(dtime)
    -- Track current time
    ambient_sounds.update_current_time(dtime)

    last_check_time = last_check_time + dtime

    if last_check_time >= ambient_sounds.config.check_interval then
        last_check_time = 0

        local connected_players = core.get_connected_players()
        for _, player in ipairs(connected_players) do
            local player_name = player:get_player_name()
            if player_name then
                ambient_sounds.update_player_sounds(player_name)
            end
        end
    end
end)

-- Handle player join
core.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    ambient_sounds.active_sounds[player_name] = {}
    ambient_sounds.random_sounds_timers[player_name] = {}

    -- Initial check with a small delay
    core.after(1.0, function()
        ambient_sounds.update_player_sounds(player_name)
    end)
end)

core.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    ambient_sounds.active_sounds[player_name] = nil
    ambient_sounds.random_sounds_timers[player_name] = nil
end)

-- Load external environments
ambient_sounds.load_external_environments()
ambient_sounds.register_external_environments()

print("[Ambient Sounds] Mod loaded!")