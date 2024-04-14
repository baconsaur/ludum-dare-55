extends MarginContainer


export var game_scene = "res://scenes/Main.tscn"


func _ready():
	get_tree().paused = true

func _on_Button_pressed():
	TransitionManager.transition_to(game_scene)
