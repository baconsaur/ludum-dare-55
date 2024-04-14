class_name DestructibleSummon
extends Summon

signal hit

export var max_hp = 5
export var weakness_group = "player"

onready var current_hp = max_hp
onready var sprite = $Sprite


func _on_DestructibleSummon_area_entered(area):
	if not area.is_in_group(weakness_group):
		return
	take_hit(area)

func initialize(init_data=null):
	if init_data and "weakness_group" in init_data:
		weakness_group = init_data["weakness_group"]
	if init_data and "max_hp" in init_data:
		max_hp = init_data["max_hp"]
		current_hp = max_hp
	.initialize(init_data)

func take_hit(bullet):
	current_hp -= 1
	emit_signal("hit", current_hp)
	bullet.queue_free()
	
	if current_hp <= 0:
		despawn()
