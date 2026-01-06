# Ambient Sounds

Ambient sound system for minetest. A lot of immersive nature sounds are tied to different biomes so exploring world will be even more satisfying. Say goodbye to silent sandbox and greet living, breathing world!

## External environment system

External environment system lets server admins create custom ambient sound zones anywhere in the world. Zone registration flow is similar to areas mod.

### Use Cases
- Create atmospheric zone for quests, events
- Add special ambient for buildings

### Chat Commands

- `/env_pos1` - Set position marker 1 at your current location
- `/env_pos2` - Set position marker 2 at your current location
- `/env_unmark` - Remove markers
- `/register_environment <name> <sound> [gain] [pitch]` - Register an external environment
  - Uses `pos1` and `pos2` as boundaries
  - Example: `/register_environment jazz restaurant_jazz 0.6 1.0`
  - Note: sound name must be registered sound
  
- `/remove_environment <id>` - Remove an external environment
  - Example: `/remove_environment 1`
  
- `/list_environments` - List registered external environments


## API

### Registering Environments

```lua
ambient_sounds.register_environment(name, tdef)
```

**Parameters:**
- `name` (string): Environment name (e.g., "forest_day")
- `tdef` (table): Environment definition with fields:
  - `biomes` (table, optional): List of biome names this applies to
  - `sounds` (table, optional): Array of sound definitions
    - `name` (string, required): Sound name
    - `gain` (number, optional): Volume (default: 0.5)
    - `pitch` (number, optional): Pitch (default: 1.0)
    - `fade_in` (number, optional): Fade in time (default: 2)
    - `fade_out` (number, optional): Fade out time (default: 2)
  - `priority` (number, required): Priority level (higher = more important)
  - `y_min`/`y_max` (number, optional): Y coordinate range
  - `nodes` (table, optional): List of node names to check
  - `env_check` (function, optional): Custom check function(tdef) -> boolean
    - `tdef` (table): Table with fields:
      - `player`: player ref
      - `pos`: player position
      - `timeofday`: time of day
      - `totals`: totals for each node e.g. tdef.totals["default:sand"]
      - `positions`: position data for every node found
      - `biome`: name of biome at current position

**Example:**
```lua
ambient_sounds.register_environment("forest_day", {
    biomes = {"deciduous_forest"},
    sounds = {
        {name = "ambient_sounds_forest_day", gain = 0.5},
    },
    env_check = function(tdef)
        return tdef.timeofday >= 0.25 and tdef.timeofday <= 0.75
    end,
    priority = 1,
})
```

### Registering Subenvironments

```lua
ambient_sounds.register_subenvironment(name, tdef)
```

**Parameters:**
- `name` (string): Subenvironment name (e.g., "water", "river")
- `tdef` (table): Subenvironment definition with fields:
  - `environments` (table, optional): List of environment names (nil = all)
  - `subenv_check` (function, required): Function(tdef) -> boolean
    - `tdef` (table): Table with fields:
      - `player`: player ref
      - `pos`: player position
      - `timeofday`: time of day
      - `totals`: totals for each node e.g. tdef.totals["default:sand"]
      - `positions`: position data for every node found
      - `biome`: name of biome at current position
  - `sounds` (table, optional): Array of sound definitions
  - `priority` (number, optional): Priority level (default: 1)
  - `nodes` (table, optional): List of node names to check

**Example:**
```lua
ambient_sounds.register_subenvironment("water", {
    environments = {"forest_day", "desert_day"},
    subenv_check = function(tdef)
        local water_count = (tdef.totals["default:water_source"] or 0) + 
                           (tdef.totals["default:water_flowing"] or 0)
        return water_count > 0
    end,
    nodes = {"default:water_source", "default:water_flowing"},
    sounds = {
        {name = "ambient_sounds_water_day", gain = 0.4},
    },
    priority = 1,
})
```

### Registering Random Sounds

```lua
ambient_sounds.register_random_sound(tdef)
```

**Parameters:**
- `tdef` (table): Random sound definition with fields:
  - `name` (string, required): Unique identifier for this random sound
  - `environments` (table, required): List of environment names (nil = all)
  - `sounds` (table, required): Array of sound definitions
  - `min_interval` (number, optional): Min interval in seconds (default: 30)
  - `max_interval` (number, optional): Max interval in seconds (default: 120)
  - `chance` (number, optional): Probability 0.0-1.0 (default: 0.3)
  - `distance` (number, optional): Distance from player in nodes (default: 50)

**Example:**
```lua
ambient_sounds.register_random_sound({
    name = "ambient_sounds_wolf_howl",
    environments = {"forest_day", "forest_night"},
    sounds = {
        {name = "ambient_sounds_wolf_howl", gain = 0.6},
    },
    min_interval = 30,
    max_interval = 120,
    chance = 0.3,
    distance = 50,
})
```

## Credits

Inspired by [ambience](https://codeberg.org/tenplus1/ambience) mod

Created by n0re5

License - MIT
