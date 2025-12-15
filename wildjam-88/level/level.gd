class_name Level extends Node3D

signal loaded
signal started
signal ended

var floor_speed: float = 0.0

@onready var chunk_path_3d: ChunkPath3D = %ChunkPath3D

func _ready() -> void:
	loaded.connect(chunk_path_3d._on_level_loaded)
	started.connect(chunk_path_3d._on_level_started)
	ended.connect(chunk_path_3d._on_level_ended)
	
	load_level()
	await chunk_path_3d.finished_spawning_initial_chunks
	start_game()

func load_level() -> void:
	print("Level: LOADED")
	loaded.emit()

func start_game() -> void:
	print("Level: GAME START")
	started.emit()

func end_game() -> void:
	print("Level: GAME END")
	ended.emit()
