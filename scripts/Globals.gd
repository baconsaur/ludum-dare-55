extends Node

export var boss_queue : Array

var boss_index = 0
var player_summons = []

var player_fire_patterns = {
	1: {
		"rotation_speed": 120,
		"fire_rate": 0.2,
		"spawn_points": 3,
		"bullet_scene": "res://scenes/PlayerBullet.tscn",
	},
	2: {
		"rotation_speed": 120,
		"fire_rate": 0.15,
		"spawn_points": 4,
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

func get_boss():
	if boss_index >= boss_queue.size():
		boss_index = 0
	var next_boss = boss_queue[boss_index]
	boss_index += 1
	return next_boss

func reset():
	boss_index = 0
