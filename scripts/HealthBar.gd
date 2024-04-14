extends TextureProgress

var segments = 1

func _ready():
	owner.connect("initialized", self, "set_init", [], CONNECT_ONESHOT)
	owner.connect("hit", self, "update_hp")

func set_init(_cm, _mm, segment_count=1):
	max_value = owner.max_hp
	value = owner.current_hp
	if segment_count:
		segments = segment_count
	color_segment(value, max_value)

func update_hp(current_hp):
	value = current_hp
	color_segment(current_hp, max_value)

func color_segment(current_hp, max_hp):
	var segment = ceil(current_hp / (max_hp / segments)) - 1
	var segment_color = Globals.get_hp_color(segment)
	tint_over = segment_color
	tint_progress = segment_color
