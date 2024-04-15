extends Node

export var boss_queue : Array
export var player_summons : Array
export var boss_index = 0
export var hp_color_segment = [Color("#bb474f"), Color("#d65709"), Color("#db7209"), Color("#df8c00"), Color("#d7ac64")]

var first_run = true

func get_boss():
	if boss_index >= boss_queue.size():
		boss_index = 0
	var next_boss = boss_queue[boss_index]
	boss_index += 1
	return next_boss

func reset():
	boss_index = 0
	player_summons = [player_summons[0]]

func get_hp_color(segment):
	return hp_color_segment[segment]
