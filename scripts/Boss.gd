class_name Boss
extends Area2D

signal initialized
signal hit
signal mana_change

export var max_hp = 50
export var max_mana = 15
export var pattern = 1
export var summon_card : PackedScene

var boss_pattern = {}

onready var current_hp = max_hp
onready var spawner = $Spawner
onready var summon_timer = $SummonTimer

func _ready():
	summon_timer.wait_time = max_mana
	summon_timer.start()
	spawner.set_pattern(boss_pattern)
	emit_signal("initialized", 0, max_mana)

func _process(_delta):
	if summon_timer.is_stopped():
		return
	emit_signal("mana_change", max_mana - summon_timer.time_left)

func summon():
	pass

func take_hit(bullet):
	bullet.queue_free()
	current_hp -= 1
	emit_signal("hit", current_hp)
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
