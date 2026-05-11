extends Spatial

export var angular_speed = 40
export var scope_zoom = 25 #Lower the value for more zoom
export var switching_time = 0.2 #Time to open or close the scope
export var zoom_amount = 25 # Lower the value for more zoom
export var zoom_time = 0.1 #Time to zoom in or out
export var zoom_ang_speed = 25  
export var default_zoom = 70

var scope = false
var zoomed = false
onready var zoom_tween: SceneTreeTween
onready var anchor = $Anchor

onready var body = $Body
onready var camera = $Body/Camera

func _physics_process(_delta):
	
	if scope:
		anchor.direction = Vector2.ZERO
		if Input.is_action_just_pressed("shoot") and scope:
			shoot()

func _input(_event):
	if not zoomed:
		if Input.is_action_just_pressed("scope"):
			scope = true
			if zoom_tween: zoom_tween.kill()
			zoom_tween = create_tween()
			zoom_tween.set_ease(Tween.EASE_OUT)
			zoom_tween.tween_property(camera, "fov", scope_zoom, switching_time)
		if Input.is_action_just_released("scope"):
			zoom_tween.kill()
			zoom_tween = create_tween()
			zoom_tween.set_ease(Tween.EASE_IN)
			zoom_tween.tween_property(camera, "fov", default_zoom, switching_time)
			yield(get_tree().create_timer(switching_time), "timeout")
			scope = false
	if not scope:
		if Input.is_action_just_pressed("zoom"):
			zoomed = true
			if zoom_tween: zoom_tween.kill()
			zoom_tween = create_tween()
			zoom_tween.set_ease(Tween.EASE_OUT)
			zoom_tween.tween_property(camera, "fov", zoom_amount, zoom_time)
		if Input.is_action_just_released("zoom"):
			zoom_tween.kill()
			zoom_tween = create_tween()
			zoom_tween.set_ease(Tween.EASE_IN)
			zoom_tween.tween_property(camera, "fov", default_zoom, zoom_time)
			yield(get_tree().create_timer(zoom_time), "timeout")
			zoomed = false

func shoot():
	pass
