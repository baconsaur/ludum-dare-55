extends TextureProgress

func _ready():
	if not owner is SummonCard:
		owner.connect("initialized", self, "set_init")
		owner.connect("mana_change", self, "update_mana")

func update_mana(current_mana):
	value = current_mana

func set_init(init_mana, init_max_mana, segments=1):
	value = init_mana
	max_value = init_max_mana
