extends Summon

export var heal_interval = 1

var heal_target : Player = null

onready var heal_timer = $HealTimer
onready var heal_particles = $HealParticles
onready var disperse_timer = $DisperseTimer
onready var area_particles = $AreaParticles

func _ready():
	heal_timer.wait_time = heal_interval
	heal_timer.connect("timeout", self, "heal")
	initialize({"life_time": max_mana})

func _process(delta):
	pass

func heal():
	if not heal_target or heal_target.current_hp >= heal_target.max_hp:
		return
	heal_particles.emitting = true
	heal_target.heal(1)

func despawn():
	area_particles.emitting = false
	disperse_timer.start()
	disperse_timer.connect("timeout", self, "finish_despawn")

func finish_despawn():
	.despawn()


func _on_HealArea_area_entered(area):
	if area is Player:
		heal_target = area
		heal_timer.start()

func _on_HealArea_area_exited(area):
	if area is Player:
		heal_target = null
		heal_timer.stop()
