class_name SummonCard
extends Node

signal activated_summon

export var summon_obj : PackedScene
export var mana_cost : int = 10
export var cooldown_time : int = 5

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

func cool_down():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = cooldown_time
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self, "finish_cooldown", [timer])

func finish_cooldown(timer):
	is_on_cooldown = false
	if summon_bar.value >= mana_cost:
		button.disabled = false
		cooldown_over_sound.play()
	timer.queue_free()

func activate_summon():
	is_on_cooldown = true
	emit_signal("activated_summon", mana_cost, summon_obj, self)

func set_mana_text():
	mana_label.text = str(summon_bar.value) + "/" + str(mana_cost)
