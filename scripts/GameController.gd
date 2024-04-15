extends Node2D

export var summon_cooldown : float = 5

var game_over_menu = preload("res://scenes/GameOver.tscn")
var level_complete_menu = preload("res://scenes/LevelComplete.tscn")
var pause_menu = preload("res://scenes/Pause.tscn")
var boss : Boss
var valid_targets = []
var current_target : Node2D
var flavor_text = ""

onready var player = $Player
onready var target_indicator = $TargetIndicator
onready var camera = $Camera2D
onready var ui = $CanvasLayer/UI
onready var tutorial = $CanvasLayer/UI/Tutorial
onready var summon_cards = $CanvasLayer/UI/SummonContainer/Summons

func _ready():
	if Globals.first_run:
		tutorial.visible = true
		Globals.first_run = false
	else:
		get_tree().paused = false
		tutorial.queue_free()
	
	var current_boss = Globals.get_boss()
	boss = current_boss.instance()
	add_child(boss)
	
	update_hp(player.current_hp)
	update_boss_hp(boss.current_hp)
	player.connect("hit", self, "update_hp", [true])
	player.connect("healed", self, "update_hp")
	player.connect("mana_change", self, "update_mana")
	boss.connect("hit", self, "update_boss_hp")
	boss.connect("spawn_obj", self, "add_target")
	boss.connect("despawn_obj", self, "remove_target")
	boss.connect("shake", camera, "shake")
	valid_targets.append(boss)
	current_target = boss
	
	flavor_text = boss.flavor_text
	
	populate_summon_cards()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		var pause_instance = pause_menu.instance()
		ui.add_child(pause_instance)
		return
	
	if Input.is_action_just_pressed("target_left"):
		shift_target(-1)
	elif Input.is_action_just_pressed("target_right"):
		shift_target(1)

	if current_target and is_instance_valid(current_target):
		player.set_target(current_target.global_position)
		if valid_targets.size() > 1:
			target_indicator.visible = true
			target_indicator.global_position = current_target.global_position
		else:
			target_indicator.visible = false

func shift_target(index_change : int):
	if valid_targets.size() <= 1:
		current_target = boss
		return

	var target_index = valid_targets.find(current_target)
	if target_index < 0:
		current_target = boss
		return

	if target_index + index_change >= valid_targets.size():
		target_index = 0
	elif target_index + index_change < 0:
		target_index = valid_targets.size() - 1
	else:
		target_index += index_change

	current_target = valid_targets[target_index]

class TargetSorter:
	static func sort_ascending_x(a : Node2D, b : Node2D):
		return a.position.x < b.position.x

func add_target(target):
	valid_targets.append(target)
	valid_targets.sort_custom(TargetSorter, "sort_ascending_x")

func remove_target(target):
	valid_targets.erase(target)
	if valid_targets.size():
		valid_targets.sort_custom(TargetSorter, "sort_ascending_x")
	if current_target == target:
		current_target = boss

func populate_summon_cards():
	var action_count = 1
	for summon in Globals.player_summons:
		var card = summon.instance()
		summon_cards.add_child(card)
		card.set_action("summon" + str(action_count))
		action_count += 1
		card.connect("activated_summon", self, "activate_summon")

func activate_summon(cost, summon_obj):
	for card in summon_cards.get_children():
		card.set_cooldown(true)
	var summon = summon_obj.instance()
	if summon.target == "player":
		player.add_child(summon)
	else:
		add_child(summon)
	if summon.target == "point":
		summon.global_position = player.global_position
	summon.connect("despawn", self, "despawn")
	player.pay_cost(cost)

func update_hp(current_hp, hit=false):
	if hit:
		camera.shake()
	if current_hp <= 0:
		player.is_dead = true
		player.die_sound.play()
		set_timer(0.5, "game_over")

func game_over(_timer):
	var game_over_instance = game_over_menu.instance()
	ui.add_child(game_over_instance)

func next_level():
	var level_complete_instance = level_complete_menu.instance()
	ui.add_child(level_complete_instance)
	level_complete_instance.call_deferred("set_text", flavor_text)

func update_boss_hp(current_hp):
	if current_hp <= 0:
		camera.shake()
		boss.connect("tree_exited", self, "next_level", [], CONNECT_ONESHOT)

func update_mana(current_mana):
	for card in summon_cards.get_children():
		card.update_mana(current_mana)

func despawn():
	set_timer(summon_cooldown, "end_summon_cooldown")

func end_summon_cooldown(timer):
	for card in summon_cards.get_children():
		card.set_cooldown(false)
		card.update_mana(player.mana)
	timer.queue_free()

func set_timer(duration, callback):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self, callback, [timer])


func _on_PauseButton_pressed():
	var pause_instance = pause_menu.instance()
	ui.add_child(pause_instance)
