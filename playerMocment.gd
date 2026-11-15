extends CharacterBody2D


var SPEED = 300.0
var lastDirection = 0
var slowSpeed = 0;
const groundResistance = 50
const airResistance = 20
const StartSpeed = 300
const JUMP_VELOCITY = -600.0
const MaxSpeed = 700.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		slowSpeed = airResistance
	else:
		slowSpeed = groundResistance

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if direction != lastDirection:
			SPEED = -40
		lastDirection = direction
		if SPEED < StartSpeed:
			SPEED = StartSpeed
		if SPEED < MaxSpeed:
			SPEED += 50
	else: if SPEED > 0:
		SPEED -= slowSpeed
	velocity.x = lastDirection * SPEED

	move_and_slide()
