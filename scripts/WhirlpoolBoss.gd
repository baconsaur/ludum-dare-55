extends Boss

export var pool_scene : PackedScene
export var pool_life = 15

onready var pool_spawn = $TurretSpawns.get_child(0)

func prepare():
	boss_patterns = [{
		"rotation_speed": 0,
		"fire_rate": 0.3,
		"bullet_speed": 80,
		"spawn_points": 16,
		"collectible_frequency": 3,
		"bullet_scene": "res://scenes/BossBullet.tscn",
	},{
		"rotation_speed": 0,
		"fire_rate": 0.25,
		"bullet_speed": 90,
		"spawn_points": 32,
		"collectible_frequency": 6,
		"bullet_scene": "res://scenes/BossBullet.tscn",
	},{
		"rotation_speed": 0,
		"fire_rate": 0.2,
		"bullet_speed": 100,
		"spawn_points": 48,
		"collectible_frequency": 6,
		"bullet_scene": "res://scenes/BossBullet.tscn",
	},{
		"rotation_speed": 25,
		"fire_rate": 0.2,
		"bullet_speed": 100,
		"spawn_points": 48,
		"collectible_frequency": 6,
		"bullet_scene": "res://scenes/BossBullet.tscn",
	}]
	.prepare()

func summon():
	var pool = pool_scene.instance()
	get_tree().current_scene.add_child(pool)
	pool.scale = Vector2(1.75, 1.75)
	pool.position = pool_spawn.global_position
	pool.initialize({"life_time": pool_life})
	pool.connect("mana_change", self, "pool_countdown", [pool])
	pool.connect("despawn", self, "pool_despawn")
	animation_player.play("summon")
	summon_sound.play()
	
func pool_despawn():
	summon_timer.start()

func pool_countdown(_current_mana, pool):
	emit_signal("mana_change",  pool.life_timer.time_left)
