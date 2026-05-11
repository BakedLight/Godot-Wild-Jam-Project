extends MeshInstance

var mouse_sensitivity: float = 0.2
var horizontal_view = 45
var vertical_ciew = 30

onready var cam = $Camera
onready var player = $".."

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#func _physics_process(_delta):
#	look_at(Vector3($"..".global_position.x, global_position.y, $"..".global_position.z), Vector3.UP)

func _physics_process(_delta):
	global_rotation.y = clamp(global_rotation.y , deg2rad(rad2deg(player.global_rotation.y)-horizontal_view), deg2rad(rad2deg(player.global_rotation.y)+horizontal_view))

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		global_rotate(Vector3.UP, deg2rad(-event.relative.x * mouse_sensitivity))
		cam.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -30, 30)
		
