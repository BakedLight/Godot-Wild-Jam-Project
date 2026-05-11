extends KinematicBody

export var speed = 8.0
export var gravity = 20.0
export var mouse_sensitivity = 0.2

var velocity = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):

	if event is InputEventMouseMotion:

		# Look left/right
		rotation_degrees.y -= event.relative.x * mouse_sensitivity

		# Look up/down
		$Camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity

		# Prevent camera flipping
		$Camera.rotation_degrees.x = clamp(
			$Camera.rotation_degrees.x,
			-90,
			90
		)

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):

	var direction = Vector3.ZERO

	var forward = -transform.basis.z
	var right = transform.basis.x

	if Input.is_action_pressed("move_forward"):
		direction += forward

	if Input.is_action_pressed("move_backward"):
		direction -= forward

	if Input.is_action_pressed("move_left"):
		direction -= right

	if Input.is_action_pressed("move_right"):
		direction += right

	direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Gravity
	velocity.y -= gravity * delta

	velocity = move_and_slide(velocity, Vector3.UP)
