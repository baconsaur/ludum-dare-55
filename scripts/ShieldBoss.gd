extends Boss


func _ready():
	boss_pattern = {
		"rotation_speed": 100,
		"fire_rate": 0.15,
		"bullet_speed": 100,
		"spawn_points": 6,
		"collectible_frequency": 2,
		"bullet_scene": "res://scenes/BossBullet.tscn",
	}
	._ready()

func summon():
	print("summon time")
