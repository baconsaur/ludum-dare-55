extends Summon

export var pull_force = 200
export var capture_groups = ["player", "actual_player", "collectible"]

var captured_objects = []

onready var disperse_timer = $DisperseTimer
onready var pool_particles = $PoolParticles


func _ready():
	if not owner is Boss:
		initialize({"life_time": max_mana})

func _process(delta):
	for obj in captured_objects:
		if not is_instance_valid(obj):
			captured_objects.erase()
		var direction = obj.global_position.direction_to(global_position)
		var force = pull_force / 2 if obj is Player else pull_force
		obj.position += direction * delta * pull_force

func despawn():
	pool_particles.emitting = false
	disperse_timer.start()
	disperse_timer.connect("timeout", self, "finish_despawn")

func finish_despawn():
	.despawn()

func _on_AoE_area_entered(area):
	if area is Boss or area is Summon:
		return
	for capture_group in capture_groups:
		if area.is_in_group(capture_group): # TODO new group for... suckable things??
			captured_objects.append(area)
			if area is Bullet and capture_group == "boss": # idc I'm running out of time
				area.can_hit = false
			break


func _on_AoE_area_exited(area):
	if area in captured_objects:
		captured_objects.erase(area)
	if is_instance_valid(area) and area is Bullet and area.is_in_group("boss"):
		area.can_hit = true

func _on_Center_area_entered(area):
	if area in captured_objects and not area is Player:
		captured_objects.erase(area)
		area.queue_free()
