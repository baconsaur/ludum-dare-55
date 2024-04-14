class_name Turret
extends DestructibleSummon

onready var spawner : Spawner = $Spawner


func initialize(init_data):
	spawner.set_pattern(init_data["pattern"])
	.initialize(init_data)
