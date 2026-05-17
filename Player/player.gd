extends Spatial

export var angular_speed = 20
export var scope_zoom = 5 #Lower the value for more zoom
export var switching_time = 0.1 #Time to open or close the scope
export var zoom_amount = 5 # Lower the value for more zoom
export var zoom_time = 0.05 #Time to zoom in or out
export var zoom_ang_speed = 5
export var default_zoom = 70

var scope = false
var zoomed = false
var target_shot

onready var zoom_tween: SceneTreeTween
onready var anchor = $Anchor
onready var body = $Body
onready var camera = $Body/Camera
onready var binoculars__texture = $"Binoculars Texture"
onready var scope__texture = $"Scope Texture"
onready var ray_cast = $Body/Camera/RayCast

func _ready():
	binoculars__texture.visible = false
	scope__texture.visible = false

func _physics_process(_delta):
	
	if scope:
		anchor.direction = Vector2.ZERO
		if Input.is_action_just_pressed("shoot"):
			shoot()

func _input(_event):
	if not zoomed:
		if Input.is_action_just_pressed("scope"):
			scope = true
			scope__texture.visible = true
			if zoom_tween: zoom_tween.kill()
			zoom_tween = create_tween()
			zoom_tween.set_ease(Tween.EASE_OUT)
			zoom_tween.tween_property(camera, "fov", scope_zoom, switching_time)
		if Input.is_action_just_released("scope"):
			scope__texture.visible = false
			zoom_tween.kill()
			zoom_tween = create_tween()
			zoom_tween.set_ease(Tween.EASE_IN)
			zoom_tween.tween_property(camera, "fov", default_zoom, switching_time)
			yield(get_tree().create_timer(switching_time), "timeout")
			scope = false
	if not scope:
		if Input.is_action_just_pressed("zoom"):
			zoomed = true
			binoculars__texture.visible = true
			if zoom_tween: zoom_tween.kill()
			zoom_tween = create_tween()
			zoom_tween.set_ease(Tween.EASE_OUT)
			zoom_tween.tween_property(camera, "fov", zoom_amount, zoom_time)
		if Input.is_action_just_released("zoom"):
			binoculars__texture.visible = false
			zoom_tween.kill()
			zoom_tween = create_tween()
			zoom_tween.set_ease(Tween.EASE_IN)
			zoom_tween.tween_property(camera, "fov", default_zoom, zoom_time)
			yield(get_tree().create_timer(zoom_time), "timeout")
			zoomed = false
		

func shoot():
	target_shot = ray_cast.get_collider()
	print(target_shot)
	if target_shot.is_in_group("npc"):
		target_shot.switch_state(target_shot.States.Die)
	if target_shot.is_in_group("innocent"):
		GameLogic.emit_signal("game_over")
	if target_shot.is_in_group("thief"):
		GameLogic.emit_signal("success")
