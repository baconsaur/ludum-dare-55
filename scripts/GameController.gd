extends Node2D

onready var player = $Player
onready var boss = $Boss
onready var debug_inventory = $CanvasLayer/UI/Debug/PlayerStats/Inventory
onready var debug_player_hp = $CanvasLayer/UI/Debug/PlayerStats/HP
onready var debug_boss_hp = $CanvasLayer/UI/Debug/BossStats/HP

func _ready():
	update_hp(player.current_hp)
	update_boss_hp(boss.current_hp)
	player.connect("hit", self, "update_hp")
	player.connect("inventory_change", self, "update_inventory")
	boss.connect("hit", self, "update_boss_hp")

func update_hp(current_hp):
	debug_player_hp.text = "Player HP: " + str(current_hp)
	if current_hp <= 0:
		print("you died")

func update_boss_hp(current_hp):
	debug_boss_hp.text = "Boss HP: " + str(current_hp)
	if current_hp <= 0:
		print("you won")

func update_inventory(current_inventory):
	debug_inventory.text = "Ammo: " + str(current_inventory)
