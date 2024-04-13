extends Area2D

signal hit

export var max_hp = 50

var current_hp = max_hp

onready var spawner = $Spawner


func take_hit(bullet):
	current_hp -= 1
	emit_signal("hit", current_hp)
	bullet.queue_free()

func _on_Boss_area_entered(area):
	if not area.is_in_group("player"):
		return
	take_hit(area)

func _on_Pattern1_pressed():
	spawner.set_pattern({
		"rotation_speed": 80,
		"fire_rate": 0.2,
		"spawn_points": 3,
		"collectible_frequency": 3,
	})

func _on_Pattern2_pressed():
	spawner.set_pattern({
		"rotation_speed": 0,
		"fire_rate": 0.1,
		"spawn_points": 8,
		"collectible_frequency": 2,
	})

func _on_Pattern3_pressed():
	spawner.set_pattern({
		"rotation_speed": 50,
		"fire_rate": 0.2,
		"spawn_points": 6,
		"collectible_frequency": 3,
	})

func _on_Pattern4_pressed():
	spawner.set_pattern({
		"rotation_speed": 150,
		"fire_rate": 0.15,
		"spawn_points": 4,
		"collectible_frequency": 8,
	})
