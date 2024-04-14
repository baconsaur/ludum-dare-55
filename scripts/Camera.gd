extends Camera2D

export var shake_time = 0.1

onready var animation_player = $AnimationPlayer


func shake():
	animation_player.play("shake")
