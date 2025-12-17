class_name Snowball extends RigidBody3D

@onready var transform_root: Node3D = %TransformRoot
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D

var rotation_speed_degrees: float = 50.0 

@export var base_rotation_speed_degrees: float = 50.0

func _init() -> void:
	rotation_speed_degrees = base_rotation_speed_degrees

func apply_rotation(delta: float) -> void:
	var rotation_value := transform_root.rotation_degrees.x + (delta * -rotation_speed_degrees)
	rotation_value = wrapf(rotation_value, 0.0, 360.0)
	
	transform_root.rotation_degrees.x = rotation_value

func hit_obstacle() -> void:
	print('hit obstacle')
