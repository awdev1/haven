extends CharacterBody2D


var SPEED = 300.0
var lastDirection = 0
var slowSpeed = 0;
const groundResistance = 50
const airResistance = 20
const StartSpeed = 300
const JUMP_VELOCITY = -350.0
const MaxSpeed = 700.0
var HumanWeight = 100
var fallMultiplier = 1.5
var jumpMultiplier = 2.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity += get_gravity() * (HumanWeight / 100.0) * fallMultiplier * delta
		else:
			velocity += get_gravity() * delta
		slowSpeed = airResistance
	else:
		slowSpeed = groundResistance

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY * jumpMultiplier

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
	else:
		if SPEED > 0:
			SPEED -= slowSpeed
	velocity.x = lastDirection * SPEED

	move_and_slide()


# Respawn if the player falls into a gap.
@onready var _start_position := global_position

func _process(_delta: float) -> void:
	if global_position.y > 1400:
		global_position = _start_position
		velocity = Vector2.ZERO
