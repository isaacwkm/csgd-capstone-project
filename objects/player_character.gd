class_name PlayerCharacter
extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

# Preload the candle scene
@export var candle_scene: PackedScene = preload("res://objects/candle.tscn")
@export var candle_init_scale: float = 1.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Define gravity here

var hasOwnCandle = false
var current_animation = ""  # Track the current animation
var facingRight = true
var heldItem: CarriableItem = null

func _physics_process(delta):
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
		facingRight = false
		update_animation(
			"walk_left" if hasOwnCandle
			else "walk_left_no_candle"
		)
	elif Input.is_action_pressed("move_right"):
		direction += 1
		facingRight = true
		update_animation(
			"walk_right" if hasOwnCandle
			else "walk_right_no_candle"
		)

	# Set velocity based on direction
	velocity.x = direction * SPEED
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Add gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump/fall animations if in the air
	if not is_on_floor():
		if facingRight:  # Moving right
			if velocity.y < 0:  # Ascending
				update_animation(
					"jump_right" if hasOwnCandle
					else "jump_right_no_candle"
				)
			elif velocity.y > 0:  # Descending
				update_animation(
					"fall_right" if hasOwnCandle
					else "fall_right_no_candle"
				)
		else:  # Moving left
			if velocity.y < 0:  # Ascending
				update_animation(
					"jump_left" if hasOwnCandle
					else "jump_left_no_candle"
				)
			elif velocity.y > 0:  # Descending
				update_animation(
					"fall_left" if hasOwnCandle
					else "fall_left_no_candle"
				)

	# Stop animation when velocity is zero
	if velocity.x == 0 and velocity.y == 0:
		if facingRight:
			update_animation(
				"stand_right" if hasOwnCandle
				else "stand_right_no_candle"
			)
		else:
			update_animation(
				"stand_left" if hasOwnCandle
				else "stand_left_no_candle"
			)
		_animated_sprite.stop()
		current_animation = ""

	move_and_slide()

# Function to play animation only if it has changed
func update_animation(animation_name):
	if current_animation != animation_name:
		_animated_sprite.play(animation_name)
		current_animation = animation_name

# Spawn a new candle when "Q" is pressed
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("break_candle") and (
		hasOwnCandle or (heldItem is Candle)
	):
		_spawn_candle()

# Function to spawn a new candle
func _spawn_candle() -> void:
	if hasOwnCandle or (heldItem is Candle):
		# resize held candle
		if heldItem is Candle: heldItem.initialize(0.5)
		
		# spawn a new candle and resize it to the held candle's scale
		var new_candle = candle_scene.instantiate() as CarriableItem
		new_candle.global_position = global_position + Vector2(50, 0) # change position if needed
		get_parent().add_child(new_candle)
		new_candle._set_scale(
			heldItem._get_scale() if heldItem is Candle
			else candle_init_scale
		)
