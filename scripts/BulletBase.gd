extends Node2D

export var speed : float = 100

onready var sprite = $Sprite


func _process(delta):
	position += transform.x * speed * delta
	sprite.global_rotation = 0


func _on_LifeTime_timeout():
	queue_free()
