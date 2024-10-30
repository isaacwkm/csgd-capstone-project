class_name ExclusiveCollisionArea
extends Area2D

static var _bookkeeping: Dictionary = {}

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _exit_tree():
	_bookkeeping.clear()

static func _record_body_entered(body: PhysicsBody2D):
	var id = body.get_instance_id()
	if (not _bookkeeping.has(id)) or _bookkeeping[id] == 0:
		_bookkeeping[id] = 1
		body.collision_layer |= 1
		body.collision_mask |= 1
	else:
		_bookkeeping[id] += 1

static func _record_body_exited(body: PhysicsBody2D):
	var id = body.get_instance_id()
	if _bookkeeping.has(id) and _bookkeeping[id] > 0:
		_bookkeeping[id] -= 1
		if _bookkeeping[id] <= 0:
			body.collision_layer &= ~1
			body.collision_mask &= ~1

func _on_body_entered(body: Node2D):
	if body is PhysicsBody2D:
		_record_body_entered(body)

func _on_body_exited(body: Node2D):
	if body is PhysicsBody2D:
		_record_body_exited(body)
