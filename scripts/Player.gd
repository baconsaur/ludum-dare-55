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


func _ready():
	emit_signal("initialized", 0, 0)

func _process(delta):
	if Input.is_action_pressed('up'):
		position.y -= delta * speed
	if Input.is_action_pressed('down'):
		position.y += delta * speed
	if Input.is_action_pressed('right'):
		position.x += delta * speed
	if Input.is_action_pressed('left'):
		position.x -= delta * speed

func _unhandled_input(event):
	if Input.is_action_pressed("fire"):
		fire()

func fire():
	if not can_fire or mana <= 0:
		return
	mana -= 1
	emit_signal("mana_change", mana)
	
	var bullet = bullet_scene.instance()
	bullet.add_to_group("player")
	get_tree().root.add_child(bullet)
	bullet.position = global_position
	bullet.rotation = get_angle_to(get_global_mouse_position())
	
	can_fire = false
	set_cooldown(fire_cooldown, "enable_fire")

func _on_Player_area_entered(area):
	if not area.is_in_group("bullet"):
		return

	if area.is_in_group("collectible"):
		collect(area)
	elif not area.is_in_group("player") and can_be_hit:
		take_hit(area)

func take_hit(bullet):
	modulate = Color.red
	current_hp -= 1
	emit_signal("hit", current_hp)
	
	can_be_hit = false
	set_cooldown(hit_time, "end_hit")
	bullet.queue_free()

func collect(bullet):
	mana += 1
	emit_signal("mana_change", mana)
	
	bullet.queue_free()
	
func end_hit(timer):
	can_be_hit = true
	modulate = Color.white
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
	emit_signal("mana_change", mana)