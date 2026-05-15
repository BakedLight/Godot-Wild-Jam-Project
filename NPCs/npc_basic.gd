extends KinematicBody

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
	Walk
	#etc.
}
var current_state = States.Idle

func _ready():
	randomize()

func _physics_process(_delta):
	
	match current_state:
		
		States.Idle:
			if wait_time.is_stopped():
				wait_time.start(rand_range(3, 6))
		
		States.Walk:
			next_location = navigation_agent.get_next_location()
			direction = (next_location - global_position).normalized()
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			look_at(Vector3(global_position.x+velocity.x, global_translation.y, global_position.z+velocity.z), Vector3.UP)
			move_and_slide(velocity)
			if navigation_agent.is_target_reached():
				switch_state(States.Idle)


func get_random_nav_point() -> Vector3:
	var point = Vector3(
		rand_range(-12, 12),
		-5,
		rand_range(-15, 21)
	)
	return navigation.get_closest_point(point)

func switch_state(final_state):
	match final_state:
		
		States.Idle:
			current_state = States.Idle
		
		States.Walk:
			current_state = States.Walk
			target = get_random_nav_point()
			while target.distance_to(global_position) <= 3:
				target = get_random_nav_point()
			navigation_agent.target_location = target


func _on_WaitTime_timeout():
	switch_state(States.Walk)
