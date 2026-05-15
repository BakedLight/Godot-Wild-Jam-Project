extends MeshInstance


onready var cube1 = $Cube1
onready var sphere1 = $Sphere1
onready var cube2 = $Cube2
onready var sphere2 = $Sphere2

var occupy := false

var default_cube1
var default_cube1_pos_y

var default_sphere1
var default_sphere1_pos_y

var default_cube2
var default_cube2_pos_y

var default_sphere2
var default_sphere2_pos_y

const FLY_TIME : float = 2.0
const DOWN_TIME : float = 1.2

var timer : float = 0.0

enum States{
	Cube_fly,
	Cube_down,
	Sphere_fly,
	Sphere_down
}

var current_state

var steal := false

var temp_cube
var temp_sphere 

var fly_max

var npc

func _ready():
	default_cube1 = cube1.transform
	default_cube1_pos_y = cube1.global_transform.origin.y
	
	default_sphere1 = sphere1.transform
	default_sphere1_pos_y = default_cube1_pos_y
	
	default_cube2 = cube2.transform
	default_cube2_pos_y = cube2.global_transform.origin.y
	
	default_sphere2 = sphere2.transform
	default_sphere2_pos_y = default_cube2_pos_y
	
	sphere1.visible = false
	sphere2.visible = false
	
	set_physics_process(false)




func _on_interact_display(body):
	npc = body
	
	fly_max = body.which_display.default_cube1_pos_y + 60 * 0.01667
	
	body.which_display.occupy = true
	
	if body.is_thief == true and body.steal == true:
		steal = true
		if body.which_display.sphere1.visible == true and body.which_display.sphere2.visible == true:
			steal = false
			var value = randi() % 2
			match value:
				0: 
					temp_cube = body.which_display.cube1
					temp_sphere = body.which_display.sphere1
					body.which_display.current_state = States.Sphere_fly
				1: 
					temp_cube = body.which_display.cube2
					temp_sphere = body.which_display.sphere2
					body.which_display.current_state = States.Sphere_fly
		elif body.which_display.sphere1.visible == false:
			temp_cube = body.which_display.cube1
			temp_sphere = body.which_display.sphere1
			body.which_display.current_state = States.Cube_fly
		elif body.which_display.sphere2.visible == false:
			temp_cube = body.which_display.cube2
			temp_sphere = body.which_display.sphere2
			body.which_display.current_state = States.Cube_fly
	else:
		steal = false
		if body.which_display.sphere1.visible == false and body.which_display.sphere2.visible == true or body.which_display.sphere1.visible == true and body.which_display.sphere2.visible == false or body.which_display.sphere1.visible == true and body.which_display.sphere2.visible == true:
			var value = randi() % 2
			match value:
				0: 
					temp_cube = body.which_display.cube1
					temp_sphere = body.which_display.sphere1
					if body.which_display.sphere1.visible == true:
						body.which_display.current_state = States.Sphere_fly
					else:
						body.which_display.current_state = States.Cube_fly
				1: 
					temp_cube = body.which_display.cube2
					temp_sphere = body.which_display.sphere2
					if body.which_display.sphere2.visible == true:
						body.which_display.current_state = States.Sphere_fly
					else:
						body.which_display.current_state = States.Cube_fly
		elif body.which_display.sphere1.visible == false:
			temp_cube = body.which_display.cube1
			temp_sphere = body.which_display.sphere1
			body.which_display.current_state = States.Cube_fly
		elif body.which_display.sphere2.visible == false:
			temp_cube = body.which_display.cube2
			temp_sphere = body.which_display.sphere2
			body.which_display.current_state = States.Cube_fly
	
	body.which_display.timer = body.which_display.FLY_TIME
	set_physics_process(true)

func _physics_process(delta):
	npc.which_display.timer -= delta
	
	match npc.which_display.current_state:
		States.Cube_fly:
			if temp_cube.position.y >= fly_max:
				temp_cube.rotate_object_local(Vector3.FORWARD, 4 * delta)
			else:
				temp_cube.position.y += 1 * delta
			
			if npc.which_display.timer <= 0:
				if steal:
					temp_sphere.translation = temp_cube.translation
					temp_sphere.visible = true
					npc.which_display.timer = npc.which_display.FLY_TIME
					temp_cube.visible = false
					temp_sphere.visible = true
					npc.which_display.current_state = States.Sphere_fly
					GameLogic.emit_signal("score_changed")
				else:
					npc.which_display.current_state = States.Cube_down
					npc.which_display.timer = npc.which_display.DOWN_TIME
		
		States.Cube_down:
			if temp_cube.position.y < npc.which_display.default_cube1_pos_y:
				if temp_cube == npc.which_display.cube1:
					temp_cube.transform = npc.which_display.default_cube1
				else:
					temp_cube.transform = npc.which_display.default_cube2
			else:
				temp_cube.position.y -= 1 * delta
			
			if npc.which_display.timer <= 0:
				npc.which_display.occupy = false
				set_physics_process(false)
				npc.which_display = null
				npc.moving()
		
		States.Sphere_fly:
			if temp_sphere.position.y >= fly_max:
				temp_sphere.rotate_object_local(Vector3.FORWARD, 4 * delta)
			else:
				temp_sphere.position.y += 1 * delta
			
			if npc.which_display.timer <= 0:
				npc.which_display.current_state = States.Sphere_down
				npc.which_display.timer = npc.which_display.DOWN_TIME
		
		States.Sphere_down:
			if temp_sphere.position.y < npc.which_display.default_sphere1_pos_y:
				if temp_sphere == npc.which_display.sphere1:
					temp_sphere.transform = npc.which_display.default_sphere1
				else:
					temp_sphere.transform = npc.which_display.default_sphere2
			else:
				temp_sphere.position.y -= 1 * delta
			
			if npc.which_display.timer <= 0:
				npc.which_display.occupy = false
				set_physics_process(false)
				npc.which_display = null
				npc.moving()

