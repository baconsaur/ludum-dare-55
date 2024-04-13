class_name Boss
extends Area2D

signal initialized
signal hit
signal mana_change

export var turret_scene : PackedScene
export var max_hp = 50
export var max_mana = 30
export var turret_hp = 5

var current_hp = max_hp
var turrets = {}

onready var spawner = $Spawner
onready var summon_timer = $SummonTimer
onready var turret_spawns = $TurretSpawns
onready var patterns = get_node("/root/Globals").enemy_fire_patterns

func _ready():
	randomize()
	for turret in turret_spawns.get_children():
		turrets[turret] = null
	summon_timer.wait_time = max_mana
	summon_timer.start()
	emit_signal("initialized", 0, max_mana)

func _process(_delta):
	emit_signal("mana_change", max_mana - summon_timer.time_left)

func take_hit(bullet):
	current_hp -= 1
	emit_signal("hit", current_hp)
	bullet.queue_free()

func summon_turret():
	for spawn in turret_spawns.get_children():
		if not turrets[spawn]:
			var turret : Turret = turret_scene.instance()
			turrets[spawn] = turret
			get_tree().root.add_child(turret)
			turret.position = spawn.global_position
			turret.initialize({
				"life_time": max_mana,
				"pattern": patterns.values()[randi() % patterns.size()],
				"max_hp": turret_hp,
				"weakness_group": "player",
			})
			turret.connect("tree_exited", self, "clear_turret_spawn", [spawn])
			break

func clear_turret_spawn(spawn):
	turrets[spawn] = null

func _on_Boss_area_entered(area):
	if not area.is_in_group("player"):
		return
	take_hit(area)

func _on_Pattern1_pressed():
	spawner.set_pattern(patterns[1])

func _on_Pattern2_pressed():
	spawner.set_pattern(patterns[2])

func _on_Pattern3_pressed():
	spawner.set_pattern(patterns[3])

func _on_Pattern4_pressed():
	spawner.set_pattern(patterns[4])

func _on_SummonTimer_timeout():
	summon_turret()
