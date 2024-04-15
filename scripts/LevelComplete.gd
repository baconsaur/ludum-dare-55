extends MarginContainer

export var game_scene = "res://scenes/Main.tscn"

onready var title = $Background/MarginContainer/VBoxContainer/Title
onready var icon = $Background/MarginContainer/VBoxContainer/Container/VBoxContainer/TextureRect
onready var body_text = $Background/MarginContainer/VBoxContainer/Container/VBoxContainer/Label

func _ready():
	get_tree().paused = true

func set_text(title_text, text_content, texture):
	title.text = title_text
	icon.texture = texture
	body_text.text = text_content

func _on_Button_pressed():
	TransitionManager.transition_to(game_scene)
