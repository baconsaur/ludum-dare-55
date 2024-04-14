class_name Spawner
extends Node2D

export var bullet_type : PackedScene
export var collectible_type : PackedScene
export var rotation_speed : float = 80
export var fire_rate : float = 0.2
export var spawn_points : int = 3
export var spawn_radius : float = 10
export var collectible_frequency : float = 0.1  #TODO make this more flexible
export var start_delay : float = 1
var count_since_collectible = 0

onready var fire_timer = $FireTimer
onready var rotator = $Rotator

func _ready():
	set_timer(start_delay, "initialize")

func initialize(timer=null):
	if timer:
		timer.queue_free()
	for spawn in rotator.get_children():
		spawn.queue_free()

	var step = 2 * PI / spawn_points
	
	for i in range(spawn_points):
		var spawn_point = Node2D.new()
		var spawn_position = Vector2(spawn_radius, 0).rotated(step * i)
		spawn_point.position = spawn_position
		spawn_point.rotation = spawn_position.angle()
		rotator.add_child(spawn_point)
	
	fire_timer.wait_time = fire_rate
	fire_timer.start()

func _process(delta):
	var new_angle = rotator.rotation_degrees + rotation_speed * delta
	rotator.rotation_degrees = fmod(new_angle, 360)

func fire():
	for spawn in rotator.get_children():
		var bullet
		if collectible_frequency and count_since_collectible >= collectible_frequency:
			count_since_collectible = 0
			bullet = collectible_type.instance()
		else:
			count_since_collectible += 1
			bullet = bullet_type.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.position = spawn.global_position
		bullet.rotation = spawn.global_rotation

func set_pattern(pattern_data):
	if "bullet_scene" in pattern_data:
		bullet_type = load(pattern_data["bullet_scene"])
	if "rotation_speed" in pattern_data:
		rotation_speed = pattern_data["rotation_speed"]
	if "fire_rate" in pattern_data:
		fire_rate = pattern_data["fire_rate"]
	if "spawn_points" in pattern_data:
		spawn_points = pattern_data["spawn_points"]
	if "collectible_frequency" in pattern_data:
		collectible_frequency = pattern_data["collectible_frequency"]
	initialize()


func _on_FireTimer_timeout():
	fire()


func set_timer(duration, callback):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self, callback, [timer])
