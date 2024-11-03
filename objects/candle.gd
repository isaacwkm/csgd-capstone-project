class_name Candle
extends CarriableItem

@onready var _collision_light = $CollisionEnablingLight

# Initialize the candle with specific properties
func initialize(scale_factor: float) -> void:
	if _collision_light:
		_collision_light.scale *= scale_factor

func _get_scale() -> Vector2:
	return _collision_light.scale

func _set_scale(_new_scale: Vector2):
	if _collision_light:
		_collision_light.scale = _new_scale
