extends Node2D

export var summon_cooldown : float = 5

var game_over_menu = preload("res://scenes/GameOver.tscn")
var level_complete_menu = preload("res://scenes/LevelComplete.tscn")
var boss : Boss

onready var player = $Player
onready var camera = $Camera2D
onready var ui = $CanvasLayer/UI
onready var summon_cards = $CanvasLayer/UI/SummonContainer/Summons
onready var summon_data = Globals.summon_data


func _ready():
	var current_boss = Globals.get_boss()
	boss = current_boss.instance()
	add_child(boss)
	
	update_hp(player.current_hp)
	update_boss_hp(boss.current_hp)
	player.connect("hit", self, "update_hp", [true])
	player.connect("mana_change", self, "update_mana")
	boss.connect("hit", self, "update_boss_hp")
	
	populate_summon_cards()

func populate_summon_cards():
	for summon in Globals.player_summons:
		var card = summon.instance()
		summon_cards.add_child(card)
		card.connect("activated_summon", self, "activate_summon")

func activate_summon(cost, summon_obj):
	for card in summon_cards.get_children():
		card.set_cooldown(true)
	var summon = summon_obj.instance()
	if summon.target == "player":
		player.add_child(summon)
	else:
		add_child(summon)
	summon.connect("despawn", self, "despawn")
	player.pay_cost(cost)

func update_hp(current_hp, hit=false):
	if hit:
		camera.shake()
	if current_hp <= 0:
		player.is_dead = true
		set_timer(0.5, "game_over")

func game_over(_timer):
	var game_over_instance = game_over_menu.instance()
	ui.add_child(game_over_instance)

func next_level(_timer):
	var level_complete_instance = level_complete_menu.instance()
	ui.add_child(level_complete_instance)

func update_boss_hp(current_hp):
	if current_hp <= 0:
		camera.shake()
		set_timer(0.5, "next_level")

func update_mana(current_mana):
	for card in summon_cards.get_children():
		card.update_mana(current_mana)

#func spawn(summon_data):
#	var summon : Summon = load(summon_data["scene"]).instance()
#	add_child(summon)
#	if "spawn_location" in summon_data:
#		summon.position = summon_data["spawn_location"]
#	else:
#		summon.position = player.global_position
#	summon.initialize(summon_data["init_data"])
#	summon_active = true
#	summon.connect("despawn", self, "despawn")

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
