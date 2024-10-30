class_name ExclusiveCollisionArea
extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body is PhysicsBody2D:
		body.collision_layer |= 1
		body.collision_mask |= 1

func _on_body_exited(body: Node2D):
	if body is PhysicsBody2D:
		body.collision_layer &= ~1
		body.collision_mask &= ~1
