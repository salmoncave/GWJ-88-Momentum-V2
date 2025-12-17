class_name ChunkPath3D extends Path3D

signal finished_spawning_initial_chunks

const PATH_LENGTH := 100.0
const CHUNK_LENGTH := 10.0

@export var base_speed: float = 1.0

@export var chunk_scene_weights: Dictionary[PackedScene, int]

#@export var level_chunk_packed_scene: PackedScene

var current_speed: float = 0.0
var acceleration: float = 1.0
var is_active: bool = true
var _path_nodes_progress_ratios: Dictionary[PathFollow3D, float]

@onready var chunk_spawn_timer: Timer = %ChunkSpawnTimer
#var _path_nodes_progress: Dictionary[PathFollow3D, float]

func _ready() -> void:
	current_speed = base_speed

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("split"):
		_spawn_new_chunk_on_path()
	_process_path_movement(delta, current_speed)
	#current_speed += (acceleration * delta)

func _on_level_loaded() -> void:
	_spawn_initial_chunks()

func _on_level_started() -> void:
	#_start_chunk_interval_timer()
	is_active = true

func _on_level_ended() -> void:
	chunk_spawn_timer.stop()
	is_active = false

func _process_path_movement(delta: float, path_speed: float) -> void:
	if _path_nodes_progress_ratios.is_empty() or not is_active: 
		return
	
	for path_follow_node in _path_nodes_progress_ratios:
		var speed_value := ((path_speed / PATH_LENGTH) * delta)
		var new_path_progress_ratio := path_follow_node.progress_ratio + speed_value
		
		if new_path_progress_ratio >= 1.0:
			_remove_chunk_from_path(path_follow_node)
		else:
			path_follow_node.progress_ratio = new_path_progress_ratio
			_path_nodes_progress_ratios[path_follow_node] = new_path_progress_ratio
			

func _spawn_initial_chunks() -> void:
	#var spawn_count: int = (int(PATH_LENGTH)/int(CHUNK_LENGTH))
	var spawn_count: int = 10
	
	for i in range(spawn_count):
		var new_chunk := _spawn_new_chunk_on_path()
		new_chunk.progress_ratio = float(i)/float(spawn_count)
	
	finished_spawning_initial_chunks.emit()

func _spawn_new_chunk_on_path() -> PathFollow3D:
	var path_follow_node := PathFollow3D.new()
	var level_chunk_node := chunk_scene_weights.keys().pick_random().instantiate() as LevelChunk
	
	add_child(path_follow_node)
	path_follow_node.add_child(level_chunk_node)
	
	level_chunk_node.generate_chunk() 
	
	path_follow_node.progress_ratio = 0.0
	_path_nodes_progress_ratios[path_follow_node] = path_follow_node.progress_ratio
	
	return path_follow_node

func _start_chunk_interval_timer() -> void:
	chunk_spawn_timer.start(_get_chunk_spawn_interval_seconds())

func _remove_chunk_from_path(chunk_path_follow_node: PathFollow3D) -> void:
	if _path_nodes_progress_ratios.has(chunk_path_follow_node):
		_path_nodes_progress_ratios.erase(chunk_path_follow_node)
	
	chunk_path_follow_node.queue_free.call_deferred()
	_spawn_new_chunk_on_path()

func _get_chunk_spawn_interval_seconds() -> float:
	var interval_seconds := (
		1  / (current_speed * (CHUNK_LENGTH / PATH_LENGTH))
	)
	print('Interval: ', interval_seconds)
	return interval_seconds


func _on_chunk_spawn_timer_timeout() -> void:
	if not is_active:
		push_error("Attempted to start chunk spawn timer while inactive")
		return
	
	_spawn_new_chunk_on_path()
	
