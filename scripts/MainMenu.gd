extends Control

export var game_scene = "res://scenes/Main.tscn"

onready var master_sound = AudioServer.get_bus_index("Master")

func _on_Button_pressed():
	TransitionManager.transition_to(game_scene)


func _on_MuteButton_toggled(button_pressed):
	AudioServer.set_bus_mute(master_sound, button_pressed)
