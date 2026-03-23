ambient_sounds.config = {
        -- Enable debug logging
    debug_mode = core.settings:get_bool("ambient_sounds_debug") or false,
        -- Interval for checking the environment (in seconds)
    check_interval = tonumber(core.settings:get("ambient_sounds_interval")) or 2.0,
        -- Nodes detection radius 
        -- Tune for performace, may cause performance issues if 
        -- too high and many players are connected
        -- 8-15 is a good range
    detection_radius = tonumber(core.settings:get("ambient_sounds_detection")) or 15,
        -- Time for fading in/out when switching sounds (in seconds)
    fade_time = tonumber(core.settings:get("ambient_sounds_fade")) or 4.0,
        -- Default gain
    gain = tonumber(core.settings:get("ambient_sounds_gain")) or 0.5,
        -- Ocean water count threshold (tune with detection radius!!)
    ocean_water_count = tonumber(core.settings:get("ambient_sounds_water")) or 200
}