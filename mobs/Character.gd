extends Area2D
class_name Character

enum STATE {IDLE, MOVING, BACK}

export var speed = 0
export(STATE) var state = STATE.IDLE
export(Constants.DIRECTIONS) var direction = Constants.DIRECTIONS.RIGHT

var velocity = Vector2()

func _ready():
	animate()

func flip():
	match direction:
		Constants.DIRECTIONS.LEFT:
			$Body.flip_h = false
		Constants.DIRECTIONS.RIGHT:
			$Body.flip_h = true

func animate():
	match state:
		STATE.MOVING:
			$Body.play("moving")
		STATE.IDLE:
			$Body.play("idle")
		STATE.BACK:
			$Body.play("back")

func start_moving(dir = Constants.DIRECTIONS.RIGHT):
	velocity = Vector2()
	direction = dir
	match direction:
		Constants.DIRECTIONS.LEFT:
			velocity.x = -1
		Constants.DIRECTIONS.RIGHT:
			velocity.x = 1
	velocity = velocity * speed
	state = STATE.MOVING
	flip()
	animate()

func stop_moving():
	state = STATE.IDLE
	velocity = Vector2()
	animate()
	
func turn_back():
	state = STATE.BACK
	velocity = Vector2()
	animate()

func _process(delta):
	position += velocity * delta
