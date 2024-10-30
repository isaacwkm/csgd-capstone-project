class_name Candle
extends RigidBody2D

@onready var _player = $'../PlayerCharacter'
@onready var _pick_area = $'PickArea'

var picked = false
var in_contact = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pick_area.body_entered.connect(_on_body_entered)
	_pick_area.body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if picked:
		global_position = _player.global_position
		linear_velocity = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if(Input.is_key_pressed(KEY_E)):
		if picked:
			picked = false
			_player.canPick = true
		elif in_contact and _player.canPick:
			picked = true
			_player.canPick = false

func _on_body_entered(body: Node2D):
	if body == _player:
		in_contact = true

func _on_body_exited(body: Node2D):
	if body == _player:
		in_contact = false
