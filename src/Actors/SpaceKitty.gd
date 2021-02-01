extends Area2D


var meowed := false
export(String, FILE) var next_scene_path := "res://src/Screens/EndScreen.tscn"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


	
func _on_MeowPlayer_finished():
	get_tree().change_scene(next_scene_path)
	get_tree().paused = false


func _on_body_entered(body):
	$MeowPlayer.play()
