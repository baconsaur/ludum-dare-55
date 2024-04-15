class_name Boss
extends Area2D

signal initialized
signal hit
signal mana_change
signal spawn_obj
signal despawn_obj

export var max_hp = 50
export var max_mana = 15
export var pattern = 1
export var summon_card : PackedScene
export var flavor_text = "Lorem ipsum"
export var boss_name = "Ted"

var boss_patterns = []
var current_pattern = 0

onready var current_hp = max_hp
onready var spawner = $Spawner
onready var summon_timer = $SummonTimer

func _ready():
	call_deferred("prepare") # Because _ready is stupid

func _process(_delta):
	if summon_timer.is_stopped():
		return
	emit_signal("mana_change", max_mana - summon_timer.time_left)

func prepare():
	summon_timer.wait_time = max_mana
	summon_timer.start()
	if boss_patterns.size() > 0:
		spawner.set_pattern(boss_patterns[current_pattern])
	emit_signal("initialized", 0, max_mana, boss_patterns.size())

func summon():
	pass

func take_hit(bullet):
	bullet.queue_free()
	current_hp -= 1
	emit_signal("hit", current_hp)
	var hp_segment = ceil(current_hp / (max_hp / boss_patterns.size())) + 1
	if current_pattern < boss_patterns.size() - hp_segment:
		current_pattern += 1
		spawner.reset(boss_patterns[current_pattern])
	if current_hp <= 0:
		die()

func die():
	if summon_card:
		Globals.player_summons.append(summon_card)
	# TODO dramatic death animation
	queue_free()

func _on_Boss_area_entered(area : Area2D):
	if area.is_in_group("bullet") and area.is_in_group("player"):
		take_hit(area)

func _on_SummonTimer_timeout():
	summon()
