extends CanvasLayer

var next_scene

onready var color_rect = $ColorRect
onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("Fade In")

func transition_to(scene_path):
	get_tree().paused = true
	next_scene = scene_path
	animation_player.play("Fade Out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out" and next_scene:
		get_tree().change_scene(next_scene)
		get_tree().paused = false
		animation_player.play("Fade In")
		next_scene = null
