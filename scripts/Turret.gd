class_name Turret
extends DestructibleSummon

onready var spawner : Spawner = $Spawner


func initialize(init_data):
	spawner.set_pattern(init_data["pattern"])
	# Debug
	if init_data["pattern"]["owner_group"] == "player":
		sprite.modulate = Color.chartreuse
	.initialize(init_data)
