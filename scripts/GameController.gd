extends Node2D

var summon_active = false

# Debug UI
onready var debug_mana = $CanvasLayer/UI/Debug/PlayerStats/Inventory
onready var debug_summon_1 = $CanvasLayer/UI/Debug/Summons/Summon1/Button
onready var debug_summon_2 = $CanvasLayer/UI/Debug/Summons/Summon2/Button

onready var player = $Player
onready var boss = $Boss
onready var camera = $Camera2D
onready var summon_data = get_node("/root/Globals").summon_data
onready var debug_buttons = {
	1: debug_summon_1,
	2: debug_summon_2,
}

func _ready():
	update_hp(player.current_hp)
	update_boss_hp(boss.current_hp)
	player.connect("hit", self, "update_hp", [true])
	player.connect("mana_change", self, "update_mana")
	boss.connect("hit", self, "update_boss_hp")

func update_hp(current_hp, hit=false):
	if hit:
		camera.shake()
	if current_hp <= 0:
		print("you died")

func update_boss_hp(current_hp):
	if current_hp <= 0:
		print("you won")

func update_mana(current_mana):
	debug_mana.text = "Mana: " + str(current_mana)
	for summon in summon_data:
		if summon_active or current_mana < summon_data[summon]["cost"]:
			debug_buttons[summon].disabled = true
		else:
			debug_buttons[summon].disabled = false

func spawn(summon_data):
	var summon : Summon = load(summon_data["scene"]).instance()
	add_child(summon)
	if "spawn_location" in summon_data:
		summon.position = summon_data["spawn_location"]
	else:
		summon.position = player.global_position
	summon.initialize(summon_data["init_data"])
	summon_active = true
	summon.connect("despawn", self, "despawn")

func despawn():
	summon_active = false
	update_mana(player.mana)

func _on_Summon1_pressed():
	spawn(summon_data[1])
	player.pay_cost(summon_data[1]["cost"])

func _on_Summon2_pressed():
	spawn(summon_data[2])
	player.pay_cost(summon_data[2]["cost"])
