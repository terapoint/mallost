extends Position2D
class_name Spawner

export(Resource) var mob
export(float) var timer_min = 1
export(float) var timer_max = 5
export(int) var mob_z_index = 0
export(int) var mob_speed = 50
export(Constants.DIRECTIONS) var direction = Constants.DIRECTIONS.RIGHT

func add_mob(node):
	$Mobs.add_child(node)

func add_object(obj):
	$Items.add_child(obj)

func _randomize_timer():
	$Timer.wait_time = rand_range(timer_min, timer_max)

func _ready():
	randomize()
	Events.connect("spawn", self, "_on_spawn_requested")
	_randomize_timer()
	if mob:
		$Timer.start()

func _on_Timer_timeout():
	Events.emit_signal("request_spawn", self, mob.instance())

func _on_spawn_requested(spawner, e):
	if spawner != self && spawner != mob:
		return
	e.speed = mob_speed
	e.position = position
	e.z_index = mob_z_index
	add_mob(e)
	e.start_moving(direction)
	_randomize_timer()
