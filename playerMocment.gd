extends CharacterBody2D


var SPEED = 300.0
var lastDirection = 0
var slowSpeed = 0;
const groundResistance = 50
const airResistance = 20
const StartSpeed = 300
const JUMP_VELOCITY = -325.0
const MaxSpeed = 700.0
var HumanWeight = 100
var fallMultiplier = 1.5
var jumpMultiplier = 2.0
@export var maxTiltDegrees := 20.0
@export var tiltSmoothing := 10.0
@export var bounceBoost := 120.0
@export var boostMaxSpeed := 1100.0
@export var boostDecay := 60.0

var squishAmount = 10;
	

func _physics_process(delta: float) -> void:
	if scale.x > 1:
		var x = scale.x - 0.02
		var y = scale.y + 0.02
		scale = Vector2(x, y)
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
		scale = Vector2(1.2, 0.8)
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
		elif SPEED > MaxSpeed:
			SPEED = move_toward(SPEED, MaxSpeed, boostDecay * delta)
		if is_on_floor():
			SPEED = minf(SPEED + bounceBoost * clampf(absf(velocity.x) / MaxSpeed, 0.0, 1.0), boostMaxSpeed)
	else:
		if SPEED > 0:
			SPEED -= slowSpeed
	velocity.x = lastDirection * SPEED

	move_and_slide()

	var target_tilt := deg_to_rad(maxTiltDegrees) * clampf(velocity.x / boostMaxSpeed, -1.0, 1.0)
	$Sprite2D.rotation = lerp_angle($Sprite2D.rotation, target_tilt, clampf(tiltSmoothing * delta, 0.0, 1.0))


@onready var _start_position := global_position

func _process(_delta: float) -> void:
	#if scale.x > 1:
		#var x = scale.x - 0.01
		#var y = scale.y + 0.01
		#scale = Vector2(x, y)
	if global_position.y > 1400:
		global_position = _start_position
		velocity = Vector2.ZERO
