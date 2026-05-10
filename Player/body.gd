extends MeshInstance

var mouse_sensitivity: float = 0.2

onready var cam = $Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		cam.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x , -120, -60)
		rotation_degrees.y = clamp(rotation_degrees.y , -45, 45)
