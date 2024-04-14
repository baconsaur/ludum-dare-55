extends Summon

var turrets = []

func _ready():
	for turret in get_children():
		turret.initialize()
		turret.connect("despawn", self, "handle_despawn", [turret])
		turrets.append(turret)
	._ready()

func handle_despawn(turret):
	turrets.erase(turret)
	if not turrets.size():
		despawn()
