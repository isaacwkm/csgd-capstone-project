class_name CarriableItem
extends RigidBody2D

@onready var _player: PlayerCharacter = $'../PlayerCharacter'
@onready var _pick_area = $'PickArea'

var in_contact = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pick_area.body_entered.connect(_on_body_entered)
	_pick_area.body_exited.connect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	if _player.heldItem == self:
		global_position = _player.global_position + Vector2.UP * 32
		linear_velocity = _player.get_real_velocity()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("pick_up"):
		if _player.heldItem == self:
			_player.heldItem = null
		elif in_contact and _player.heldItem == null:
			_player.heldItem = self

func _on_body_entered(body: Node2D):
	if body == _player:
		in_contact = true

func _on_body_exited(body: Node2D):
	if body == _player:
		in_contact = false

func is_carried():
	return _player.heldItem == self
