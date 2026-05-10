extends Spatial

export var angular_speed = 40
export var scope_zoom = 40 #Lower the value for more zoom
export var switching_time = 0.2 #Time to open or close the scope
export var default_zoom = 70

var direction = 0
var scope = false

onready var camera = $Body/Camera

func _physics_process(delta):
	if not scope:
		if Input.is_action_pressed("move_left"):
			direction = -1
		if Input.is_action_pressed("move_right"):
			direction = 1
		rotate_y(deg2rad(angular_speed * direction * delta))
		direction = 0
	else:
		direction = 0
		if Input.is_action_just_pressed("shoot"):
			shoot()

func _input(_event):
	if Input.is_action_just_pressed("scope"):
		scope = true
		var zoom_tween = create_tween()
		zoom_tween.set_ease(Tween.EASE_OUT)
		zoom_tween.tween_property(camera, "fov", scope_zoom, switching_time)
	if Input.is_action_just_released("scope"):
		var zoom_tween = create_tween()
		zoom_tween.set_ease(Tween.EASE_IN)
		zoom_tween.tween_property(camera, "fov", default_zoom, switching_time)

func shoot():
	pass
