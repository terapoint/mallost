extends Position2D
class_name Spawner

export(Resource) var mob
export(float) var timer_min = 1
export(float) var timer_max = 5
export(int) var mob_z_index = 0
export(int) var mob_speed = 50
export(Constants.DIRECTIONS) var direction = Constants.DIRECTIONS.RIGHT

func _randomize_timer():
	$Timer.wait_time = rand_range(timer_min, timer_max)

func _ready():
	randomize()
	Events.connect("spawn", self, "_on_spawn_requested")
	_randomize_timer()
	$Timer.start()

func _generate_mob():
	var e = mob.instance()
	e.position = position
	e.z_index = mob_z_index
	e.speed = mob_speed
	return e

func _on_Timer_timeout():
	Events.emit_signal("request_spawn", self, _generate_mob())

func _on_spawn_requested(spawner, e):
	if spawner != self:
		return
	get_parent().add_child(e)
	e.start_moving(direction)
	_randomize_timer()
