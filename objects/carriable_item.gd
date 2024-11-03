class_name CarriableItem
extends RigidBody2D

@onready var _player: PlayerCharacter = $'../PlayerCharacter'
@onready var _pick_area = $'PickArea'
@onready var _collision_light = $CollisionEnablingLight

var in_contact = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pick_area.body_entered.connect(_on_body_entered)
	_pick_area.body_exited.connect(_on_body_exited)

# Initialize the candle with specific properties
func initialize(scale_factor: float) -> void:
	if _collision_light:
		_collision_light.scale *= scale_factor

func _get_scale() -> Vector2:
	return _collision_light.scale

func _set_scale(_new_scale: Vector2):
	if _collision_light:
		_collision_light.scale = _new_scale

func _physics_process(_delta: float) -> void:
	if _player.heldItem == self:
		global_position = _player.global_position + Vector2.UP * 32
		linear_velocity = _player.get_real_velocity()

func _input(event: InputEvent) -> void:
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