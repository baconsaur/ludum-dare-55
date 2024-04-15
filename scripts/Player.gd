class_name Player
extends Area2D

signal initialized
signal healed
signal hit
signal mana_change

export var start_mana = 0 # Debug
export var speed : float = 200
export var hit_radius : float = 3
export var hit_time : float = 1
export var max_hp : int = 10
export var fire_cooldown : float = 0.25

var bullet_scene = preload("res://scenes/PlayerBullet.tscn")
var current_hp = max_hp
var can_fire = true
var can_be_hit = true
var mana = start_mana
var is_dead = false
var overlapping_danger = false
var target_position = Vector2(0, -60)
var upper_bound = Vector2.ZERO
var lower_bound = Vector2.ZERO

onready var mana_particles = $ManaParticles
onready var mana_label = $HUD/Stats/Mana/ManaLabel
onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite

onready var hit_sound = $Hit
onready var die_sound = $Die
onready var heal_sound = $Heal
onready var pickup_sound = $Pickup
onready var summon_sound = $Summon
onready var shoot_sound = $Shoot

func _ready():
	var viewport_rect = get_viewport().get_visible_rect()
	var sprite_size = Vector2(sprite.texture.get_width(), sprite.texture.get_height())
	lower_bound = viewport_rect.position + sprite_size / 4 - viewport_rect.size / 2
	upper_bound = viewport_rect.end - sprite_size / 4 - viewport_rect.size / 2
	
	emit_signal("initialized", 0, 0)

func _process(delta):
	if is_dead:
		return

	if Input.is_action_pressed('up'):
		position.y = clamp(position.y - delta * speed, lower_bound.y, upper_bound.y)
	if Input.is_action_pressed('down'):
		position.y = clamp(position.y + delta * speed, lower_bound.y, upper_bound.y)
	if Input.is_action_pressed('right'):
		position.x = clamp(position.x + delta * speed, lower_bound.x, upper_bound.x)
	if Input.is_action_pressed('left'):
		position.x = clamp(position.x - delta * speed, lower_bound.x, upper_bound.x)
	
	sprite.global_rotation = get_angle_to(target_position) + (90 * PI / 180)
	
	if Input.is_action_pressed('fire'):
		fire()

	if overlapping_danger and can_be_hit:
		take_hit()
	
	if not animation_player.is_playing():
		animation_player.play("idle")

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
	bullet.rotation = get_angle_to(target_position)
	bullet.sprite.modulate = sprite.modulate
#	shoot_sound.play() Too annoying
	can_fire = false
	set_cooldown(fire_cooldown, "enable_fire")

func _on_Player_area_entered(area):
	if area.is_in_group("collectible") and not overlapping_danger:
		collect(area)
	elif area.is_in_group("boss") and can_be_hit:
		if "can_hit" in area and not area.can_hit:
			return
		take_hit(area)

func heal(amount):
	if current_hp >= max_hp:
		return
	current_hp += amount
	heal_sound.play()
	emit_signal("healed", current_hp)

func take_hit(target=null):
	animation_player.play("hit")
	current_hp -= 1
	hit_sound.play()
	emit_signal("hit", current_hp)
	
	can_be_hit = false
	set_cooldown(hit_time, "end_hit")
	
	if not target:
		return
	elif target.is_in_group("bullet"):
		target.queue_free()
	elif target is Boss:
		overlapping_danger = true

func set_target(coords : Vector2):
	target_position = coords

func collect(bullet):
	mana += 1
	pickup_sound.play()
	mana_label.text = str(mana)
	emit_signal("mana_change", mana)
	mana_particles.emitting = true
	
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
	summon_sound.play()
	emit_signal("mana_change", mana)

func _on_Player_area_exited(area):
	if area is Boss:
		overlapping_danger = false
