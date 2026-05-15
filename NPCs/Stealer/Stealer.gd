extends KinematicBody

#Shiv
export var speed: int = 10

var nav_mesh: NavigationMeshInstance
var direction: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
var target: Vector3 = Vector3.ZERO
var next_location


onready var navigation: Navigation = $".."
onready var navigation_agent = $NavigationAgent
onready var wait_time = $WaitTime

enum States{
	Idle,
	Walk,
	Seek_Spot,
	Rest,
	Observe,
	Interact
}
var current_state = States.Idle

#Yu Narukami
var is_thief: bool =  true
var steal: bool = false

var display
var which_display

var spot
var which_spot

var spot_index

var min_wait = 1
var max_wait = 2

func _ready():
	randomize()
	
	display = get_tree().get_nodes_in_group("display")
	spot = get_tree().get_nodes_in_group("spot")

func _physics_process(_delta):
	match current_state:
		
		States.Idle:
			if wait_time.is_stopped():
				wait_time.start(rand_range(min_wait, max_wait))
		
		States.Walk:
			next_location = navigation_agent.get_next_location()
			direction = (next_location - global_position).normalized()
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			look_at(Vector3(
				global_position.x + velocity.x, 
				global_translation.y, 
				global_position.z + velocity.z), 
				Vector3.UP
				)
			move_and_slide(velocity)
			
			if navigation_agent.is_target_reached():
				switch_state(States.Idle)
		
		States.Seek_Spot:
			next_location = navigation_agent.get_next_location()
			direction = (next_location - global_position).normalized()
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			look_at(Vector3(
				global_position.x + velocity.x, 
				global_translation.y, 
				global_position.z + velocity.z), 
				Vector3.UP
				)
			move_and_slide(velocity)
			
			if navigation_agent.is_navigation_finished():
				match spot_index:
					0:
						rotation_degrees = Vector3(0, 180, 0)
					2:
						rotation_degrees = Vector3(0, -90, 0)
					3, 4:
						rotation_degrees = Vector3(0, 90, 0)
				
				switch_state(States.Rest)
		
		States.Rest:
			if wait_time.is_stopped():
				wait_time.start(rand_range(min_wait, max_wait))
		
		States.Observe:
			next_location = navigation_agent.get_next_location()
			direction = (next_location - global_position).normalized()
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			look_at(Vector3(
				global_position.x + velocity.x, 
				global_translation.y, 
				global_position.z + velocity.z), 
				Vector3.UP
				)
			move_and_slide(velocity)
			
			if navigation_agent.is_target_reached():
				if which_display.occupy:
					moving()
				else:
					var value = randi() % 2
					match value:
						0: steal = true
						1: steal = false
					look_at(which_display.global_position, Vector3.UP)
					which_display._on_interact_display(self)
					switch_state(States.Interact)
		
		States.Interact:
			pass


func get_random_nav_point() -> Vector3:
	var point = Vector3(
		rand_range(-12, 12),
		-5,
		rand_range(-15, 21)
	)
	return navigation.get_closest_point(point)

func switch_state(final_state):
	
	current_state = final_state
	
	match final_state:
		
		States.Idle:
			pass
		
		States.Walk:
			target = get_random_nav_point()
			while target.distance_to(global_position) <= 3:
				target = get_random_nav_point()
			navigation_agent.target_location = target
		
		States.Seek_Spot:
			if spot.size() > 0:
				spot_index = randi() % spot.size()
				which_spot = spot[spot_index]
				var plane_size = which_spot.mesh.size
				var plane_pos  = which_spot.global_translation

				var rand_x = rand_range(-plane_size.x / 2, plane_size.x / 2)
				var rand_z = rand_range(-plane_size.y / 2, plane_size.y / 2)
				
				var target_spot = Vector3(plane_pos.x + rand_x, plane_pos.y, plane_pos.z + rand_z)
				navigation_agent.target_location = target_spot
		
		States.Rest:
			pass
		
		States.Observe:
			if display.size() > 0:
				which_display = display[randi() % display.size()]
				var pos = which_display.get_node("Position3D")
				
				navigation_agent.target_location = pos.global_position
		
		States.Interact:
			pass


func _on_WaitTime_timeout():
	moving()

func moving():
	var value = randi() % 3
	match value:
		0: switch_state(States.Walk)
		1: switch_state(States.Seek_Spot)
		2: switch_state(States.Observe)
