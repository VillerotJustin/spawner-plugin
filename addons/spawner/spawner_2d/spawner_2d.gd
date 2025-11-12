@tool
@icon("res://addons/spawner/spawner_2d/spawner_2d_icon.svg")
extends Marker2D
class_name Spawner2D

@export_category("Scenes")
@export var scenes_list: Array[PackedScene]

@export_category("Spawn parameters")
@export var spawn_on_load: bool = false # start spawning on spawner load
@export var continuous_spawn: bool = false # spawn once or continuously in a coroutine
@export var use_marker_as_parent:bool = false # Use the spawn points as parrent or instanciate under the root of the scene
@export_enum("Random", "Ordered-ASC", "Ordered-DSC", "Wave") var spawn_type:String = "Ordered-ASC"
@export_enum("Random", "Ordered-ASC", "Ordered-DSC") var spawnpoint_selection_type:String = "Ordered-ASC"
@export var number_of_spawn_point_to_use: int = -1 # Max number of spawn point to use, use all if -1
@export var spawn_interval: float = 0 # Time between instaciation in seconds
@export var wave_interval: float = 0 # Time between wave in seconds
#TODO wave info something like array of array of int the later representing the distribution of the number of instance needed to spawn

var spawn_points: Array[Marker2D]

# Plugin Shenanigans
func _enable_plugin() -> void:
	# Add autoloads here.
	pass

func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

# Actual Plugin
func _ready() -> void:
	load_spawn_points()
	if spawn_on_load:
		if continuous_spawn:
			# TODO continuous spawn coroutine
			pass
		else:
			# Make this coroutine to  ??
			spawn_instances()
			
func load_spawn_points() -> void:
	var childrens: Array[Node] = get_children()
	spawn_points.clear()
	for children in childrens:
		if children is Marker2D:
			spawn_points.append(children)

func spawn_instances() -> void:
	match spawn_type:
		"Random":
			random_spawn()
		"Ordered-ASC":
			ordered_spawn()
		"Ordered-DSC":
			ordered_spawn(false)
		"Wave":
			wave_spawn()
		_:
			push_error("Invalid Spawn Type")

func random_spawn() -> void:
	var selected_spawn_points: Array[Marker2D]
	var counter:int  = 0
	match spawnpoint_selection_type: 
		"Random":
			selected_spawn_points = select_random_spawn_points()
		"Ordered-ASC":
			selected_spawn_points = select_spawn_points()
		"Ordered-DSC":
			selected_spawn_points = select_spawn_points(false)
		_:
			push_error("Invalid Spawnpoints Selection Type")
			
	for spawnpoint in selected_spawn_points:
		instanciate_scene(randi_range(0, scenes_list.size()-1), spawnpoint)
	
func ordered_spawn(ASC: bool = true) -> void:
	# Get the spawn_points that will be used
	var selected_spawn_points: Array[Marker2D]
	var counter:int  = 0
	
	counter = 0
	for spawnpoint in selected_spawn_points:
		if ASC:
			instanciate_scene(counter % scenes_list.size(), spawnpoint)
		else:
			instanciate_scene((scenes_list.size()-1-counter) % scenes_list.size(), spawnpoint)
		counter += 1
		

func wave_spawn() -> void:
	push_warning("Unimplemented")
	pass
	
# Selecting spawn points
	
func get_selected_spawn_points() -> Array[Marker2D]:
	match spawnpoint_selection_type: 
		"Random":
			return select_random_spawn_points()
		"Ordered-ASC":
			return select_spawn_points()
		"Ordered-DSC":
			return select_spawn_points(false)
		_:
			push_error("Invalid Spawnpoints Selection Type")
			return []

func select_random_spawn_points() -> Array[Marker2D]:
	var selected_spawn_points: Array[Marker2D]
	if number_of_spawn_point_to_use == -1:
		selected_spawn_points = spawn_points
		selected_spawn_points.shuffle()
		return selected_spawn_points
	
	for i in range(number_of_spawn_point_to_use):
		selected_spawn_points.append(spawn_points[randi_range(0, spawn_points.size()-1)])
	return selected_spawn_points

func select_spawn_points(ASC: bool = true) -> Array[Marker2D]:
	var selected_spawn_points: Array[Marker2D]
	var counter:int = 0
	if ASC:
		for spawnpoint in spawn_points:
			if number_of_spawn_point_to_use != -1 and counter >= number_of_spawn_point_to_use:
				break
			
			selected_spawn_points.append(spawnpoint)
			
			counter+=1
	else :
		var revered_spawn_points = spawn_points.duplicate()
		revered_spawn_points.reverse()
		for spawnpoint in revered_spawn_points:
			if number_of_spawn_point_to_use != -1 and counter >= number_of_spawn_point_to_use:
				break
			
			selected_spawn_points.append(spawnpoint)
			
			counter+=1
	return selected_spawn_points

# Instancing
	
func instanciate_scene(scene_id: int, spawnpoint: Marker2D) -> void :
	var instance = scenes_list[scene_id].instantiate()
	instance.global_position = spawnpoint.global_position
	
	if use_marker_as_parent:
		spawnpoint.add_child(instance)
	else:
		var root = get_tree().get_current_scene()
		if root:
			root.add_child(instance)
		else:
			get_tree().get_root().add_child(instance)
	await get_tree().create_timer(spawn_interval).timeout
	
