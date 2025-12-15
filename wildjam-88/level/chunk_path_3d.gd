class_name ChunkPath3D extends Path3D

@export var base_speed: float = 1.0
@export var chunk_length: float = 10.0

@export_group("Packed Scenes")
@export var level_chunk_packed_scene: PackedScene

var current_speed: float = 0.0
var is_level_active: bool = true
var _path_nodes_progress_ratios: Dictionary[PathFollow3D, float]

@onready var chunk_spawn_timer: Timer = %ChunkSpawnTimer
#var _path_nodes_progress: Dictionary[PathFollow3D, float]

func _ready() -> void:
	current_speed = base_speed

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("split"):
		spawn_new_chunk_on_path()
	process_path_movement(delta, current_speed)

func process_path_movement(delta: float, path_speed: float) -> void:
	if _path_nodes_progress_ratios.is_empty() or not is_level_active: 
		return
	
	for path_follow_node in _path_nodes_progress_ratios:
		var new_path_progress_ratio := path_follow_node.progress_ratio + (path_speed * delta)
		
		if new_path_progress_ratio >= 1.0:
			_remove_chunk_from_path(path_follow_node)
		else:
			path_follow_node.progress_ratio = new_path_progress_ratio
			_path_nodes_progress_ratios[path_follow_node] = new_path_progress_ratio
			
	

func spawn_new_chunk_on_path() -> void:
	var path_follow_node := PathFollow3D.new()
	var level_chunk_node := level_chunk_packed_scene.instantiate() as LevelChunk
	
	add_child(path_follow_node)
	path_follow_node.add_child(level_chunk_node)
	
	path_follow_node.progress_ratio = 0.0
	_path_nodes_progress_ratios[path_follow_node] = path_follow_node.progress_ratio
	

func _remove_chunk_from_path(chunk_path_follow_node: PathFollow3D) -> void:
	if _path_nodes_progress_ratios.has(chunk_path_follow_node):
		_path_nodes_progress_ratios.erase(chunk_path_follow_node)
	
	chunk_path_follow_node.queue_free.call_deferred()

func _get_chunk_spawn_interval_seconds() -> float:
	return (chunk_length / current_speed)


func _on_chunk_spawn_timer_timeout() -> void:
	if not is_level_active:
		return
	spawn_new_chunk_on_path()
	chunk_spawn_timer.start(_get_chunk_spawn_interval_seconds())
