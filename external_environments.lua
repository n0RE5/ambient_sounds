-- Position storage for environment boundaries
ambient_sounds.pos1 = {}
ambient_sounds.pos2 = {}

-- Storage for external environments
ambient_sounds.client_environments = {}
ambient_sounds.next_env_id = 1

local function get_external_envs_path()
    return core.get_worldpath() .. "/external_environments.dat"
end

local function remove_marker_entities(pos, entity_name)
    if not pos then
        return
    end
    local objects = core.objects_inside_radius(pos, 1)
    for obj in objects do
        if obj and obj:get_luaentity() and obj:get_luaentity().name == entity_name then
            obj:remove()
        end
    end
end

function ambient_sounds.set_pos1(player_name, pos)
    local old = ambient_sounds.pos1[player_name]
    if old then
        remove_marker_entities(old, "ambient_sounds:pos_1")
    end
    ambient_sounds.pos1[player_name] = pos
    if pos then
        core.add_entity(pos, "ambient_sounds:pos_1")
    end
end

function ambient_sounds.set_pos2(player_name, pos)
    local old = ambient_sounds.pos2[player_name]
    if old then
        remove_marker_entities(old, "ambient_sounds:pos_2")
    end
    ambient_sounds.pos2[player_name] = pos
    if pos then
        core.add_entity(pos, "ambient_sounds:pos_2")
    end
end

function ambient_sounds.unmark(player_name)
    local pos1 = ambient_sounds.pos1[player_name]
    local pos2 = ambient_sounds.pos2[player_name]
    
    if pos1 then
        remove_marker_entities(pos1, "ambient_sounds:pos_1")
    end
    if pos2 then
        remove_marker_entities(pos2, "ambient_sounds:pos_2")
    end
    
    ambient_sounds.pos1[player_name] = nil
    ambient_sounds.pos2[player_name] = nil
end

local function pos_handler(player_name, param, posn)
    local player = core.get_player_by_name(player_name)
    if not player then
        return false, "Player not found"
    end
    local pos = player:get_pos()
    if pos then
        pos = vector.round(pos)
    end
    if posn == 1 then
        ambient_sounds.set_pos1(player_name, pos)
    elseif posn == 2 then
        ambient_sounds.set_pos2(player_name, pos)
    end
    return true, "Position " .. tostring(posn) .. " is set to " .. core.pos_to_string(pos)
end

-- Load external environments from file
function ambient_sounds.load_external_environments()
    local path = get_external_envs_path()
    local file = io.open(path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        if content and content ~= "" then
            local success, data = pcall(core.deserialize, content)
            if success and data then
                ambient_sounds.client_environments = data.environments or {}
                ambient_sounds.next_env_id = data.next_id or 1
                core.log("action", "[Ambient Sounds] Loaded " .. 
                    #ambient_sounds.client_environments .. " external environments")
                return true
            else
                core.log("error", "[Ambient Sounds] Failed to deserialize external environments")
            end
        end
    end
    return false
end

local function save_external_environments()
    local path = get_external_envs_path()
    local data = {
        environments = ambient_sounds.client_environments,
        next_id = ambient_sounds.next_env_id
    }
    local serialized = core.serialize(data)
    local success = core.safe_file_write(path, serialized)
    if success then
        core.log("action", "[Ambient Sounds] Saved " .. 
            #ambient_sounds.client_environments .. " external environments")
        return true
    else
        core.log("error", "[Ambient Sounds] Failed to save external environments")
        return false
    end
end

local function pos_check(pos1, pos2)
    return function(tdef)
        local pos = tdef.pos
        local min_x = math.min(pos1.x, pos2.x)
        local max_x = math.max(pos1.x, pos2.x)
        local min_y = math.min(pos1.y, pos2.y)
        local max_y = math.max(pos1.y, pos2.y)
        local min_z = math.min(pos1.z, pos2.z)
        local max_z = math.max(pos1.z, pos2.z)
        
        return pos.x >= min_x and pos.x <= max_x and
               pos.y >= min_y and pos.y <= max_y and
               pos.z >= min_z and pos.z <= max_z
    end
end

-- Register external environments from table
function ambient_sounds.register_external_environments()
    for _, env_data in ipairs(ambient_sounds.client_environments) do
        if env_data.pos1 and env_data.pos2 then
            local env_name = "external_environment_" .. env_data.id .. "_" .. env_data.name
            ambient_sounds.register_environment(env_name, {
                biomes = {},
                sounds = {
                    {
                        name = env_data.sound,
                        gain = env_data.gain,
                        pitch = env_data.pitch,
                    }
                },
                priority = 4, -- Override all other environments
                env_check = pos_check(env_data.pos1, env_data.pos2),
            })
        end
    end
end

-- Register an external environment
local function register_external_environment(name, sound, gain, pitch, pos1, pos2)
    if not name or not sound then
        return false, "Name and sound are required"
    end
    
    gain = gain or ambient_sounds.config.gain
    pitch = pitch or 1.0
    
    -- Assign id -> increment counter
    local env_id = ambient_sounds.next_env_id
    ambient_sounds.next_env_id = ambient_sounds.next_env_id + 1
    
    local env_name = "external_environment_" .. env_id .. "_" .. name
    
    -- Add new environment
    table.insert(ambient_sounds.client_environments, {
        id = env_id,
        name = name,
        sound = sound,
        gain = gain,
        pitch = pitch,
        pos1 = pos1,
        pos2 = pos2,
    })
    save_external_environments()
    
    -- Register environment
    ambient_sounds.register_environment(env_name, {
        biomes = {},
        sounds = {
            {
                name = sound,
                gain = gain,
                pitch = pitch,
            }
        },
        priority = 4,
        env_check = pos_check(pos1, pos2),
    })
    
    return true, "Environment '" .. name .. "' registered with id " .. env_id
end

-- Remove an external environment
local function remove_external_environment(env_id)
    if not env_id then
        return false, "Environment id is required"
    end
    
    env_id = tonumber(env_id)
    if not env_id then
        return false, "Environment id must be a number"
    end
    
    -- Find and remove from storage
    for i, env in ipairs(ambient_sounds.client_environments) do
        if env.id == env_id then
            local env_name = "external_environment_" .. env.id .. "_" .. env.name
            table.remove(ambient_sounds.client_environments, i)
            save_external_environments()
            
            if ambient_sounds.environments[env_name] then
                ambient_sounds.environments[env_name] = nil
            end
            
            return true, "Environment '" .. env.name .. "' (id: " .. env_id .. ") removed"
        end
    end
    
    return false, "Environment with id " .. env_id .. " not found"
end

-- Marker entities
core.register_entity("ambient_sounds:pos_1", {
    initial_properties = {
        visual = "cube",
        visual_size = {x = 1.05, y = 1.05, z = 1.05},
        textures = {
            "ambient_sounds_pos_1.png",
            "ambient_sounds_pos_1.png",
            "ambient_sounds_pos_1.png",
            "ambient_sounds_pos_1.png",
            "ambient_sounds_pos_1.png",
            "ambient_sounds_pos_1.png",
        },
        physical = false,
        collide_with_objects = false,
        pointable = true,
        is_visible = true,
        static_save = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    
    on_rightclick = function(self, clicker)
        if clicker and clicker:is_player() then
            local pos = self.object:get_pos()
            if pos then
                core.chat_send_player(clicker:get_player_name(), 
                    "Position marker at: " .. core.pos_to_string(vector.round(pos)))
            end
        end
    end,
})

core.register_entity("ambient_sounds:pos_2", {
    initial_properties = {
        visual = "cube",
        visual_size = {x = 1.05, y = 1.05, z = 1.05},
        textures = {
            "ambient_sounds_pos_2.png",
            "ambient_sounds_pos_2.png",
            "ambient_sounds_pos_2.png",
            "ambient_sounds_pos_2.png",
            "ambient_sounds_pos_2.png",
            "ambient_sounds_pos_2.png",
        },
        physical = false,
        collide_with_objects = false,
        pointable = true,
        is_visible = true,
        static_save = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    
    on_rightclick = function(self, clicker)
        if clicker and clicker:is_player() then
            local pos = self.object:get_pos()
            if pos then
                core.chat_send_player(clicker:get_player_name(), 
                    "Position marker at: " .. core.pos_to_string(vector.round(pos)))
            end
        end
    end,
})

-- Chat commands
core.register_chatcommand("env_pos1", {
    params = "",
    privs = {server = true},
    description = "Set the environment registration position 1 to your current location",
    func = function(name, param)
        return pos_handler(name, param, 1)
    end
})

core.register_chatcommand("env_pos2", {
    params = "",
    privs = {server = true},
    description = "Set the environment registration position 2 to your current location",
    func = function(name, param)
        return pos_handler(name, param, 2)
    end
})

core.register_chatcommand("env_unmark", {
    params = "",
    privs = {server = true},
    description = "Unmark the current position markers",
    func = function(name, param)
        ambient_sounds.unmark(name)
        return true, "Position markers removed"
    end
})

core.register_chatcommand("register_environment", {
    params = "<name> <sound> [gain] [pitch]",
    privs = {server = true},
    description = "Register a custom environment using pos1 and pos2 as boundaries",
    func = function(name, param)
        local env_name, sound, rest = string.match(param, "^(%S+) ([^ ]+)(.*)$")
        local gain, pitch
        if rest then
            local parts = {}
            for part in string.gmatch(rest, "%S+") do
                table.insert(parts, part)
            end
            gain = parts[1] and tonumber(parts[1]) or nil
            pitch = parts[2] and tonumber(parts[2]) or nil
        end
        
        if not env_name or not sound then
            return false, "Usage: /register_environment <name> <sound> [gain] [pitch]"
        end
        
        -- Get positions for current player
        local pos1 = ambient_sounds.pos1[name]
        local pos2 = ambient_sounds.pos2[name]
        
        if not pos1 or not pos2 then
            return false, "Boundaries are not set"
        end

        local success, msg = register_external_environment(env_name, sound, gain, pitch, pos1, pos2)
        
        if not success then
            return false, msg
        end

        -- Remove markers on success
        ambient_sounds.unmark(name)

        return success, msg
    end
})

core.register_chatcommand("remove_environment", {
    params = "<id>",
    privs = {server = true},
    description = "Remove an external environment",
    func = function(name, param)
        local env_id = string.match(param, "^(%S+)$")
        if not env_id then
            return false, "Usage: /remove_environment <id>"
        end
        
        return remove_external_environment(env_id)
    end
})

core.register_chatcommand("list_environments", {
    params = "",
    privs = {server = true},
    description = "List all registered external environments",
    func = function(name, param)
        if #ambient_sounds.client_environments == 0 then
            return true, "No external environments registered"
        end
        
        local list = {}
        for _, env in ipairs(ambient_sounds.client_environments) do
            table.insert(list, "id:" .. env.id .. " " .. env.name .. " sound=" .. env.sound 
                .. " pos1=" .. core.pos_to_string(env.pos1) 
                .. " pos2=" .. core.pos_to_string(env.pos2))
        end
        return true, "External environments: " .. table.concat(list, ", ")
    end
})