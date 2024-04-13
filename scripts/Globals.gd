extends Node

var enemy_fire_patterns = {
		1: {
		"rotation_speed": 80,
		"fire_rate": 0.2,
		"spawn_points": 3,
		"collectible_frequency": 3,
		"owner_group": "boss",
		"bullet_scene": "res://scenes/BossBullet.tscn",
	},
	2: {
		"rotation_speed": 0,
		"fire_rate": 0.5,
		"spawn_points": 16,
		"collectible_frequency": 4,
		"owner_group": "boss",
		"bullet_scene": "res://scenes/BossBullet.tscn",
	},
	3: {
		"rotation_speed": 50,
		"fire_rate": 0.2,
		"spawn_points": 6,
		"collectible_frequency": 3,
		"owner_group": "boss",
		"bullet_scene": "res://scenes/BossBullet.tscn",
	},
	4: {
		"rotation_speed": 150,
		"fire_rate": 0.15,
		"spawn_points": 4,
		"collectible_frequency": 8,
		"owner_group": "boss",
		"bullet_scene": "res://scenes/BossBullet.tscn",
	},
}

var player_fire_patterns = {
	1: {
		"rotation_speed": 120,
		"fire_rate": 0.25,
		"spawn_points": 2,
		"collectible_frequency": 0,
		"owner_group": "player",
		"bullet_scene": "res://scenes/PlayerBullet.tscn",
	},
	2: {
		"rotation_speed": 120,
		"fire_rate": 0.15,
		"spawn_points": 4,
		"collectible_frequency": 0,
		"owner_group": "player",
		"bullet_scene": "res://scenes/PlayerBullet.tscn",
	}
}

var summon_data = {
	1: {
		"cost": 10,
		"scene": "res://scenes/Turret.tscn",
		"init_data": {
			"life_time": 30,
			"pattern": player_fire_patterns[1],
			"max_hp": 20,
			"weakness_group": "boss",
		},
	},
	2: {
		"cost": 20,
		"scene": "res://scenes/Turret.tscn",
		"init_data": {
			"life_time": 30,
			"pattern": player_fire_patterns[2],
			"max_hp": 30,
			"weakness_group": "boss",
		},
	},
}
