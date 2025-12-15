class_name Snowball extends Node3D

@onready var transform_root: Node3D = %TransformRoot
@onready var rigid_body_3d: RigidBody3D = %RigidBody3D
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D

func _physics_process(delta: float) -> void:
	apply_rotation(delta, 100.0)

func apply_rotation(delta: float, rotation_speed_degrees: float) -> void:
	var rotation_value := transform_root.rotation_degrees.x + (delta * -rotation_speed_degrees)
	rotation_value = wrapf(rotation_value, 0.0, 360.0)
	
	transform_root.rotation_degrees.x = rotation_value
