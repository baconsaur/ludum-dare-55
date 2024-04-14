extends Boss

export var shield_scene : PackedScene
export var shield_life: float = 8

func _ready():
	boss_pattern = {
		"rotation_speed": 95,
		"fire_rate": 0.15,
		"bullet_speed": 100,
		"spawn_points": 6,
		"collectible_frequency": 2,
		"bullet_scene": "res://scenes/BossBullet.tscn",
	}
	._ready()

func summon():
	if not shield_scene:
		return
	var shield : Node2D = shield_scene.instance()
	shield.scale = Vector2(2, 2)
	add_child(shield)
	shield.initialize({"life_time": shield_life})
	shield.connect("mana_change", self, "shield_countdown", [shield])
	shield.connect("despawn", self, "shield_despawn")

func shield_despawn():
	summon_timer.start()

func shield_countdown(_current_mana, shield):
	emit_signal("mana_change",  shield.life_timer.time_left)
