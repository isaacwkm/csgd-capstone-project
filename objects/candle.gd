class_name Candle
extends RigidBody2D

var picked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if picked:
		self.position = get_node("../PlayerCharacter/Marker2D").global_position

func _input(event: InputEvent) -> void:
	if(Input.is_key_pressed(KEY_E)):
		if picked:
			picked = false
			get_node("../PlayerCharacter").canPick = true
		else:
			if get_node("../PlayerCharacter").canPick == true:
				picked = true
				get_node("../PlayerCharacter").canPick = false
