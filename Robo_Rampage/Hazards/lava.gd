extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.hitpoints = 0
	elif body.is_in_group("player"):
		body.health = 0
