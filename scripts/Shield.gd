extends Summon

export var owner_group = "boss"

onready var disperse_timer = $DisperseTimer
onready var shield_particles = $ShieldParticles

func _ready():
	if not owner is Boss:
		initialize({"life_time": max_mana})
	._ready()

func _on_ShieldArea_area_entered(area):
	if area is Bullet and not area.is_in_group(owner_group) and not area.is_in_group("collectible"):
		area.queue_free()

func despawn():
	shield_particles.emitting = false
	disperse_timer.start()
	disperse_timer.connect("timeout", self, "finish_despawn")

func finish_despawn():
	.despawn()
