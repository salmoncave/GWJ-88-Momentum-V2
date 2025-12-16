class_name SpeedManager extends Node3D

@export var speed: float = 1.0
@export var acceleration: float = 0.15

@onready var snowball: Snowball = %Snowball
@onready var chunk_path_3d: ChunkPath3D = %ChunkPath3D

func _physics_process(delta: float) -> void:
	_process_speed_operations(delta)
	pass

func _process_speed_operations(delta: float) -> void:
	speed += acceleration * delta
	speed = snappedf(speed, 0.001)
	speed = clampf(speed, 0.0, 15.0)
	
	snowball.apply_rotation(delta)
	snowball.rotation_speed_degrees += (acceleration * snowball.base_rotation_speed_degrees) * delta
	#print('snowball rotation speed: ', snowball.rotation_speed_degrees)
	
	chunk_path_3d.current_speed = speed
	print('Speed: ', speed)
