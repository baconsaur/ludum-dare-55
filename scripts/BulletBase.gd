class_name Bullet
extends Area2D

export var speed : float = 100

onready var sprite = $Sprite
onready var collider = $CollisionShape2D


func _process(delta):
	position += transform.x * speed * delta
	sprite.global_rotation = 0


func _on_LifeTime_timeout():
	queue_free()
