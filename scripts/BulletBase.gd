class_name Bullet
extends Area2D

export var speed : float = 100

var can_hit = true

onready var sprite = $Sprite
onready var collider = $CollisionShape2D


func _ready():
	sprite.global_rotation = 90

func _process(delta):
	position += transform.x * speed * delta


func _on_LifeTime_timeout():
	queue_free()
