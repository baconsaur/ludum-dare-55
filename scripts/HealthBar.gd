extends TextureProgress


func _ready():
	owner.connect("initialized", self, "set_init", [], CONNECT_ONESHOT)
	owner.connect("hit", self, "update_hp")

func set_init(_cm, _mm):
	print(owner.name)
	print(owner.current_hp)
	print(owner.max_hp)
	max_value = owner.max_hp
	value = owner.current_hp

func update_hp(current_hp):
	print(current_hp)
	value = current_hp
