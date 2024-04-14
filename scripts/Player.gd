extends Area2D

signal initialized
signal hit
signal mana_change

export var speed : float = 200
export var hit_radius : float = 3
export var hit_time : float = 1
export var max_hp : int = 10
export var fire_cooldown : float = 0.25

var bullet_scene = preload("res://scenes/PlayerBullet.tscn")
var current_hp = max_hp
var can_fire = true
var can_be_hit = true
var mana = 0
var is_dead = false
var overlapping_danger = false

onready var mana_label = $HUD/Stats/Mana/ManaLabel
onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite


func _ready():
	emit_signal("initialized", 0, 0)

func _process(delta):
	if is_dead:
		return

	if Input.is_action_pressed('up'):
		position.y -= delta * speed
	if Input.is_action_pressed('down'):
		position.y += delta * speed
	if Input.is_action_pressed('right'):
		position.x += delta * speed
	if Input.is_action_pressed('left'):
		position.x -= delta * speed
	
	if overlapping_danger and can_be_hit:
		take_hit()

func _unhandled_input(event):
	if is_dead:
		return
	if Input.is_action_pressed("fire"):
		fire()

func fire():
	if not can_fire or mana <= 0:
		return
	mana -= 1
	mana_label.text = str(mana)
	emit_signal("mana_change", mana)
	
	var bullet = bullet_scene.instance()
	bullet.add_to_group("player")
	get_tree().current_scene.add_child(bullet)
	bullet.position = global_position
	bullet.rotation = get_angle_to(get_global_mouse_position())
	
	can_fire = false
	set_cooldown(fire_cooldown, "enable_fire")

func _on_Player_area_entered(area):
	if area.is_in_group("collectible") and not overlapping_danger:
		collect(area)
	elif area.is_in_group("boss") and can_be_hit:
		take_hit(area)

func take_hit(target=null):
	animation_player.play("hit")
	current_hp -= 1
	emit_signal("hit", current_hp)
	
	can_be_hit = false
	set_cooldown(hit_time, "end_hit")
	
	if not target:
		return
	elif target.is_in_group("bullet"):
		target.queue_free()
	elif target is Boss:
		overlapping_danger = true

func collect(bullet):
	mana += 1
	mana_label.text = str(mana)
	emit_signal("mana_change", mana)
	
	bullet.queue_free()
	
func end_hit(timer):
	can_be_hit = true
	animation_player.stop(true)
	sprite.visible = true # just in case
	timer.queue_free()

func enable_fire(timer):
	can_fire = true
	timer.queue_free()

func set_cooldown(cooldown_time, callback):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = cooldown_time
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self, callback, [timer])

func pay_cost(cost):
	mana -= cost
	mana_label.text = str(mana)
	emit_signal("mana_change", mana)


func _on_Player_area_exited(area):
	if area is Boss:
		overlapping_danger = false
