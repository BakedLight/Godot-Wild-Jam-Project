extends Spatial

onready var player = $".."

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	if not player.scope:
		if Input.is_action_pressed("move_left"):
			direction.x = -1
		if Input.is_action_pressed("move_right"):
			direction.x = 1
		if Input.is_action_pressed("move_down"):
			direction.y = 1
		if Input.is_action_pressed("move_up"):
			direction.y = -1
		global_rotate(Vector3.UP, deg2rad(player.angular_speed * direction.x * delta))
		global_rotation.y = clamp(global_rotation.y, deg2rad(-30), deg2rad(30))
		rotate_object_local(Vector3(1, 0, 0), deg2rad(player.angular_speed * direction.y * delta))
		rotation_degrees.x = clamp(rotation_degrees.x, -5, 5)
		direction = Vector2.ZERO
