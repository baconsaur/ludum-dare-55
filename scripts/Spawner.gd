extends Node2D

export var bullet_type : PackedScene
export var collectible_type : PackedScene
export var rotation_speed : float = 80
export var fire_rate : float = 0.2
export var spawn_points : int = 3
export var spawn_radius : float = 10
export var collectible_frequency : float = 0.1  #TODO make this more flexible

var count_since_collectible = 0

onready var fire_timer = $FireTimer
onready var rotator = $Rotator

func _ready():
	initialize()

func initialize():
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
		if count_since_collectible >= collectible_frequency:
			count_since_collectible = 0
			bullet = collectible_type.instance()
		else:
			count_since_collectible += 1
			bullet = bullet_type.instance()
		get_tree().root.add_child(bullet)
		bullet.position = spawn.global_position
		bullet.rotation = spawn.global_rotation

func set_pattern(pattern_data):
	rotation_speed = pattern_data["rotation_speed"]
	fire_rate = pattern_data["fire_rate"]
	spawn_points = pattern_data["spawn_points"]
	collectible_frequency = pattern_data["collectible_frequency"]
	initialize()


func _on_FireTimer_timeout():
	fire()
