class_name Level extends Node3D

signal loaded
signal started
signal ended

var floor_speed: float = 0.0

@onready var chunk_path_3d: ChunkPath3D = %ChunkPath3D
@onready var directional_light_3d: DirectionalLight3D = %DirectionalLight3D

func _ready() -> void:
	loaded.connect(chunk_path_3d._on_level_loaded)
	started.connect(chunk_path_3d._on_level_started)
	ended.connect(chunk_path_3d._on_level_ended)
	
	load_level()
	await chunk_path_3d.finished_spawning_initial_chunks
	start_game()

func _physics_process(delta: float) -> void:
	return
	var rotation_speed: float = 10.0
	var nighttime_rotation_mod: float = 5.0
	
	if directional_light_3d.rotation_degrees.z < 180.0:
		rotation_speed *= nighttime_rotation_mod
	
	var desired_rotation_degress := directional_light_3d.rotation_degrees.z + (delta * rotation_speed)
	desired_rotation_degress = wrapf(desired_rotation_degress, 0.0, 360.0)
	directional_light_3d.rotation_degrees.z = desired_rotation_degress

func load_level() -> void:
	print("Level: LOADED")
	loaded.emit()

func start_game() -> void:
	print("Level: GAME START")
	started.emit()

func end_game() -> void:
	print("Level: GAME END")
	ended.emit()
