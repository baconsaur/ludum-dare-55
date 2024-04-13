class_name Summon
extends Area2D

signal initialized
signal mana_change
signal despawn

export var max_mana : float = 10

var life_timer : Timer

onready var sprite = $Sprite

func _process(_delta):
	emit_signal("mana_change", life_timer.time_left)

func initialize(init_data):
	if "life_time" in init_data:
		max_mana = init_data["life_time"]

	life_timer = Timer.new()
	add_child(life_timer)
	life_timer.wait_time = max_mana
	life_timer.one_shot = true
	life_timer.start()
	life_timer.connect("timeout", self, "despawn")
	
	emit_signal("initialized", max_mana, max_mana)

func despawn():
	emit_signal("despawn")
	queue_free()
