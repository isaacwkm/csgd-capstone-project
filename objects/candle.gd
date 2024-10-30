class_name Candle
extends RigidBody2D

@onready var _player = $'../PlayerCharacter'

var picked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if picked:
		global_position = _player.global_position

func _input(event: InputEvent) -> void:
	if(Input.is_key_pressed(KEY_E)):
		if picked:
			picked = false
			_player.canPick = true
		else:
			if _player.canPick:
				picked = true
				_player.canPick = false
