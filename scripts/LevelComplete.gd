extends MarginContainer

export var game_scene = "res://scenes/Main.tscn"

onready var body_text = $Background/MarginContainer/VBoxContainer/Container/Label

func _ready():
	get_tree().paused = true

func set_text(text_content):
	body_text.text = text_content

func _on_Button_pressed():
	TransitionManager.transition_to(game_scene)
