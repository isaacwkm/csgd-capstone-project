class_name PlayerCharacter
extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Define gravity here

var hasCandle = true
var current_animation = ""  # Track the current animation
var facingRight = true
var heldItem: Node2D = null

func _physics_process(delta):
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
		facingRight = false
		update_animation("walk_left" if hasCandle else "walk_left_no_candle")
	elif Input.is_action_pressed("move_right"):
		direction += 1
		facingRight = true
		update_animation("walk_right" if hasCandle else "walk_right_no_candle")

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
				update_animation("jump_right" if hasCandle else "jump_right_no_candle")
			elif velocity.y > 0:  # Descending
				update_animation("fall_right" if hasCandle else "fall_right_no_candle")
		else:  # Moving left
			if velocity.y < 0:  # Ascending
				update_animation("jump_left" if hasCandle else "jump_left_no_candle")
			elif velocity.y > 0:  # Descending
				update_animation("fall_left" if hasCandle else "fall_left_no_candle")

	# Stop animation when velocity is zero
	if velocity.x == 0 and velocity.y == 0:
		if facingRight:
			update_animation("stand_right" if hasCandle else "stand_right_no_candle")
		else:
			update_animation("stand_left" if hasCandle else "stand_left_no_candle")
		_animated_sprite.stop()
		current_animation = ""

	move_and_slide()

# Function to play animation only if it has changed
func update_animation(animation_name):
	if current_animation != animation_name:
		_animated_sprite.play(animation_name)
		current_animation = animation_name
