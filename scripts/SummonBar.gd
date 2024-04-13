extends TextureProgress

export var target_path : NodePath
export var summon_id = 1

var target : Node2D
onready var summon_data = get_node("/root/Globals").summon_data

func _ready():
	var target = owner
	if target_path:
		target = get_node(target_path)
		set_init(0, summon_data[summon_id]["cost"])
	else:
		target.connect("initialized", self, "set_init")
	target.connect("mana_change", self, "update_mana")

func set_init(init_mana, init_max_mana):
	value = init_mana
	max_value = init_max_mana

func update_mana(current_mana):
	value = current_mana
