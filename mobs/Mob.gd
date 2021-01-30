extends Area2D
class_name Mob

enum STATE {IDLE, MOVING, BACK}

export var speed = 0
export(STATE) var state = STATE.IDLE
export(Constants.DIRECTIONS) var direction = Constants.DIRECTIONS.RIGHT

var velocity = Vector2()

func flip():
	match direction:
		Constants.DIRECTIONS.LEFT:
			$Head.flip_h = false
			$UpperBody.flip_h = false
			$LowerBody.flip_h = false
		Constants.DIRECTIONS.RIGHT:
			$Head.flip_h = true
			$UpperBody.flip_h = true
			$LowerBody.flip_h = true

func animate():
	match state:
		STATE.MOVING:
			$Head.play("moving")
			$UpperBody.play("moving")
			$LowerBody.play("moving")
		STATE.BACK:
			$Head.play("back")
			$UpperBody.play("back")
			$LowerBody.play("back")
		STATE.IDLE:
			$Head.stop()
			$UpperBody.stop()
			$LowerBody.stop()

func start_moving(dir=Constants.DIRECTIONS.RIGHT):
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
