# Spawner Plugin API Documentation

## Overview

The Spawner Plugin provides a flexible system for spawning entities in both 2D and 3D Godot scenes using configurable waves and spawn patterns.

## Core Classes

### Spawner2D

**Extends:** `Marker2D`  
**Class Name:** `Spawner2D`  
**Icon:** `res://addons/spawner/spawner_2d/spawner_2d_icon.svg`

A 2D spawner that manages spawn points (child `Marker2D` nodes) and spawns entities based on wave configurations.

#### Exported Properties

**Scenes Category:**

- `waves: Array[Wave]` - Array of wave configurations to spawn

**Spawn Parameters Category:**

- `spawn_on_load: bool = false` - Start spawning automatically when the spawner loads
- `continuous_spawn: bool = false` - Spawn once or continuously in a coroutine
- `use_marker_as_parent: bool = false` - Use spawn points as parent or instantiate under scene root
- `spawn_type: String = "Ordered-ASC"` - Spawn pattern: "Random", "Ordered-ASC", "Ordered-DSC", "Wave"
- `spawnpoint_selection_type: String = "Ordered-ASC"` - Spawn point selection: "Random", "Ordered-ASC", "Ordered-DSC"
- `number_of_spawn_point_to_use: int = -1` - Max number of spawn points to use (-1 = all)
- `spawn_interval: float = 0` - Time between instantiations in seconds
- `wave_interval: float = 0` - Time between waves in seconds

#### Public Methods

##### Core Spawning Methods

```gdscript
func spawn_instances() -> void
```

Main spawning method that executes the configured spawn pattern.

```gdscript
func spawn_instances_coroutine() -> void
```

Coroutine wrapper for spawn_instances().

##### Spawn Pattern Methods

```gdscript
func random_spawn() -> void
```

Spawns entities randomly across selected spawn points.

```gdscript
func ordered_spawn(ASC: bool = true) -> void
```

Spawns entities in order (ascending or descending).

```gdscript
func wave_spawn() -> void
```

Spawns entities wave by wave with intervals.

##### Spawn Point Management

```gdscript
func load_spawn_points() -> void
```

Loads all child `Marker2D` nodes as spawn points.

```gdscript
func get_selected_spawn_points() -> Array[Marker2D]
```

Returns spawn points based on selection type and limits.

```gdscript
func select_random_spawn_points() -> Array[Marker2D]
```

Returns randomly selected spawn points.

```gdscript
func select_spawn_points(ASC: bool = true) -> Array[Marker2D]
```

Returns spawn points in order (ascending/descending).

##### Instantiation

```gdscript
func instantiate_scene_from_entry(wave_entry: WaveEntry, spawnpoint: Marker2D) -> void
```

Instantiates a scene from a wave entry at the specified spawn point.

#### Private Properties

- `spawn_points: Array[Marker2D]` - Array of loaded spawn point markers

### Spawner3D

**Extends:** `Marker3D`  
**Class Name:** `Spawner3D`  
**Icon:** `res://addons/spawner/spawner_3d/spawner_3d_icon.svg`

A 3D spawner with identical functionality to Spawner2D but for 3D scenes using `Marker3D` nodes.

#### Properties and Methods

Same as Spawner2D but with `Marker3D` instead of `Marker2D`:

- `spawn_points: Array[Marker3D]`
- All methods use `Marker3D` parameters instead of `Marker2D`
- `instantiate_scene_from_entry(wave_entry: WaveEntry, spawnpoint: Marker3D) -> void`

### Wave

**Extends:** `Resource`  
**Class Name:** `Wave`

Defines a wave configuration containing multiple wave entries and wave-specific settings.

#### Exported Properties

- `wave_entries: Array[WaveEntry] = []` - Array of wave entries defining what to spawn
- `wave_name: String = "Wave"` - Name identifier for the wave
- `delay_before_next_wave: float = 0.0` - Delay before spawning the next wave

### WaveEntry

**Extends:** `Resource`  
**Class Name:** `WaveEntry`

Defines a single entry in a wave, specifying what scene to spawn and how many instances.

#### Exported Properties

- `packed_scene: PackedScene` - The scene to instantiate
- `number_of_instances: int = 1` - Number of instances to spawn for this entry

## Plugin Main Class

### Spawner (EditorPlugin)

**Extends:** `EditorPlugin`

The main plugin class that registers custom node types in the Godot editor.

#### Methods

```gdscript
func _enter_tree() -> void
```

Registers Spawner2D and Spawner3D as custom node types.

```gdscript
func _exit_tree() -> void
```

Removes custom node types when plugin is disabled.

## Usage Examples

### Basic 2D Setup

1. Add a `Spawner2D` node to your scene
2. Add child `Marker2D` nodes as spawn points
3. Create `Wave` resources and assign `WaveEntry` resources with scenes
4. Configure spawn parameters in the inspector
5. Call `spawn_instances()` or enable `spawn_on_load`

### Wave Configuration

```gdscript
# Create a wave resource
var wave = Wave.new()
wave.wave_name = "Enemy Wave 1"

# Create wave entries
var entry1 = WaveEntry.new()
entry1.packed_scene = preload("res://Enemy.tscn")
entry1.number_of_instances = 5

var entry2 = WaveEntry.new()
entry2.packed_scene = preload("res://PowerUp.tscn")
entry2.number_of_instances = 2

wave.wave_entries = [entry1, entry2]
```

### Spawn Types

- **"Random"**: Randomly distributes all wave entries across selected spawn points
- **"Ordered-ASC"**: Spawns in ascending order through spawn points and wave entries
- **"Ordered-DSC"**: Spawns in descending order
- **"Wave"**: Spawns each wave completely before moving to the next, with wave intervals

### Spawn Point Selection

- **"Random"**: Randomly selects spawn points
- **"Ordered-ASC"**: Uses spawn points in order (first to last)
- **"Ordered-DSC"**: Uses spawn points in reverse order (last to first)

## Notes

- Spawn points must be direct children of the spawner node
- `use_marker_as_parent` determines whether spawned instances become children of the spawn point or the scene root
- `spawn_interval` adds delay between individual spawns
- `wave_interval` adds delay between waves (only used in "Wave" spawn type)
- The plugin automatically handles deferred instantiation to avoid timing issues
