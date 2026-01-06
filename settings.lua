-- Enable debug logging
ambient_sounds.debug_mode = false

-- Interval for checking the environment (in seconds)
ambient_sounds.check_interval = 2.0

-- Nodes detection radius 
-- Tune for performace, may cause performance issues if 
-- too high and many players are connected
-- 8-15 is a good range
ambient_sounds.detection_radius = 15

-- Time for fading in/out when switching sounds (in seconds)
ambient_sounds.fade_time = 4.0

-- Default gain
gain = ambient_sounds.gain or 0.5

-- Ocean water count threshold (tune with detection radius!!)
ambient_sounds.ocean_water_count = 200