class_name Obstacle extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Snowball:
		body.hit_obstacle()
