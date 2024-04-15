class_name SummonCard
extends Node

signal activated_summon

export var summon_obj : PackedScene
export var mana_cost : int = 10

export var action_name : String
var is_on_cooldown = false

onready var button = $CardData/Button
onready var summon_bar = $CardData/SummonBar
onready var mana_label = $CardData/SummonBar/ManaCost
onready var cooldown_over_sound = $CooldownOver

func _ready():
	summon_bar.set_init(0, mana_cost)
	set_mana_text()
	button.connect("pressed", self, "activate_summon")

func _process(delta):
	if not action_name or button.disabled:
		return

	if Input.is_action_just_pressed(action_name):
		activate_summon()

func set_action(_action_name):
	action_name = action_name

func update_mana(current_mana):
	summon_bar.update_mana(current_mana)
	if is_on_cooldown or current_mana < mana_cost:
		button.disabled = true
	elif button.disabled:
		cooldown_over_sound.play()
		button.disabled = false
	set_mana_text()

func set_cooldown(cooldown : bool):
	is_on_cooldown = cooldown

func activate_summon():
	emit_signal("activated_summon", mana_cost, summon_obj)

func set_mana_text():
	mana_label.text = str(summon_bar.value) + "/" + str(mana_cost)
