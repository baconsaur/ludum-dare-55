class_name SummonCard
extends Node

signal activated_summon

export var summon_obj : PackedScene
export var mana_cost : int = 10

var is_on_cooldown = false

onready var button = $CardData/Button
onready var summon_bar = $CardData/SummonBar

func _ready():
	summon_bar.set_init(0, mana_cost)
	button.connect("pressed", self, "activate_summon")

func update_mana(current_mana):
	summon_bar.update_mana(current_mana)
	if is_on_cooldown or current_mana < mana_cost:
		button.disabled = true
	else:
		button.disabled = false

func set_cooldown(cooldown : bool):
	is_on_cooldown = cooldown

func activate_summon():
	emit_signal("activated_summon", mana_cost, summon_obj)
