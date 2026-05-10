extends KinematicBody


const SPEED = 10

var velocity = Vector3()

func _physics_process(delta):
	var direction = Vector3()
	
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	
	if Input.get_action_strength("move_backward"):
		direction.z = 1
	if Input.get_action_strength("move_forward"):
		direction.z = -1
	
	if Input.get_action_strength("move_up"):
		direction.y = 1
	if Input.get_action_strength("move_down"):
		direction.y = -1
	
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	velocity.z = direction.z * SPEED
	
	move_and_slide(velocity)
