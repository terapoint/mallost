extends Position2D

export(Resource) var mob
export(float) var timer_min = 1
export(float) var timer_max = 5

var rng = RandomNumberGenerator.new()

func _randomize_timer():
	$Timer.wait_time = rng.randf_range(timer_min, timer_max)

func _ready():
	rng.randomize()
	_randomize_timer()
	$Timer.start()

func _on_Timer_timeout():
	var e = mob.instance()
	e.position = position
	get_parent().add_child(e)
	e.start_moving(Mob.DIRECTION.RIGHT)
	_randomize_timer()
