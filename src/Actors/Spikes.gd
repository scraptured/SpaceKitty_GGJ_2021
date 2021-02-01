extends KinematicBody2D



func _on_Area2D_body_entered(body: Node) -> void:
	if body.get("TYPE") == "player":
		get_tree().reload_current_scene() 
