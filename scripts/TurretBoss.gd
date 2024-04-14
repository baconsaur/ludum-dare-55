extends Boss

export var turret_scene : PackedScene
export var turret_hp = 5
export var turret_life = 30

var turrets = {}
var turret_pattern = {
		"rotation_speed": 15,
		"fire_rate": 0.5,
		"bullet_speed": 50,
		"spawn_points": 4,
		"collectible_frequency": 2,
		"bullet_scene": "res://scenes/BossBullet.tscn",
}

onready var turret_spawns = $TurretSpawns

func _ready():
	boss_pattern = {
		"rotation_speed": 80,
		"fire_rate": 0.2,
		"bullet_speed": 100,
		"spawn_points": 3,
		"collectible_frequency": 2,
		"bullet_scene": "res://scenes/BossBullet.tscn",
	}

	for turret in turret_spawns.get_children():
		turrets[turret] = null
	._ready()

func summon():
	for spawn in turret_spawns.get_children():
		if not turrets[spawn]:
			var turret : Turret = turret_scene.instance()
			turrets[spawn] = turret
			get_tree().current_scene.add_child(turret)
			turret.position = spawn.global_position
			turret.initialize({
				"life_time": turret_life,
				"pattern": turret_pattern,
				"max_hp": turret_hp,
				"weakness_group": "player",
			})
			turret.connect("tree_exited", self, "clear_turret_spawn", [spawn])
			break

func clear_turret_spawn(spawn):
	turrets[spawn] = null
