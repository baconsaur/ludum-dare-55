class_name Boss
extends Area2D

signal shake
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
var is_dead = false

onready var current_hp = max_hp
onready var spawner = $Spawner
onready var animation_player = $AnimationPlayer
onready var summon_timer = $SummonTimer
onready var hit_sound = $Hit
onready var die_sound = $Die
onready var pattern_sound = $PatternChange
onready var summon_sound = $Summon
onready var name_label = $Control/VBoxContainer/Label

func _ready():
	name_label.text = boss_name
	animation_player.play("RESET")
	call_deferred("prepare") # Because _ready is stupid

func _process(_delta):
	if is_dead:
		return
	if summon_timer.is_stopped():
		return
	if not animation_player.is_playing():
		animation_player.play("idle")
	emit_signal("mana_change", max_mana - summon_timer.time_left)

func prepare():
	summon_timer.wait_time = max_mana
	summon_timer.start()
	if boss_patterns.size() > 0:
		spawner.set_pattern(boss_patterns[current_pattern])
	emit_signal("initialized", 0, max_mana, boss_patterns.size())

func summon():
	animation_player.play("summon")
	summon_sound.play()
	summon_timer.start()

func take_hit(bullet):
	if is_dead:
		return
	bullet.queue_free()
	current_hp -= 1
	emit_signal("hit", current_hp)
	var hp_segment = ceil(current_hp / (max_hp / boss_patterns.size())) + 1
	
	var pattern_changed = false
	if current_pattern < boss_patterns.size() - hp_segment:
		current_pattern += 1
		pattern_changed = true
		spawner.reset(boss_patterns[current_pattern])
	if current_hp <= 0:
		die()
	else:
		if animation_player.current_animation == "idle":
			animation_player.play("hit")
			hit_sound.play()
		if pattern_changed:
			animation_player.connect("animation_finished", self, "change_pattern_anim", [], CONNECT_ONESHOT)

func change_pattern_anim(anim_name):
	if not anim_name == "hit":
		return
	animation_player.play("change_pattern")
	pattern_sound.play()

func die():
	if is_dead:
		return
	is_dead = true
	animation_player.play("die")
	animation_player.connect("animation_finished", self, "finish_dying")
	die_sound.play()
	if summon_card and not summon_card in Globals.player_summons:
		Globals.player_summons.append(summon_card)

func summon_warning():
	if animation_player.current_animation != "change_pattern":
		animation_player.play("summon_warning")
		animation_player.connect("animation_finished", self, "start_summon", [], CONNECT_ONESHOT)
	else:
		summon()

func start_summon(anim_name):
	if not anim_name == "summon_warning":
		return
	summon()

func shake_camera():
	emit_signal("shake")

func finish_dying(anim_name):
	if anim_name == "die":
		queue_free()

func _on_Boss_area_entered(area : Area2D):
	if is_dead:
		return
	if area.is_in_group("bullet") and area.is_in_group("player"):
		take_hit(area)

func _on_SummonTimer_timeout():
	if is_dead:
		return
	summon_timer.stop()
	summon_warning()
