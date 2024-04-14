class_name Summon
extends Node2D

signal initialized
signal mana_change
signal despawn

export var max_mana : float = 10
export var target = "player"

var life_timer : Timer

func _ready():
	pass

func _process(_delta):
	if not life_timer:
		return
	emit_signal("mana_change", life_timer.time_left)

func initialize(init_data=null):
	if init_data and "life_time" in init_data:
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
