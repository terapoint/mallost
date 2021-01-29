extends Area2D
class_name Mob

export var speed = 200

enum DIRECTION {NONE, LEFT, RIGHT}

var screen_size = Vector2()
var velocity = Vector2()
var _direction = DIRECTION.NONE

func _ready():
	screen_size = get_viewport_rect().size

func flip():
	match _direction:
		DIRECTION.LEFT:
			$Head.flip_h = false
			$UpperBody.flip_h = false
			$LowerBody.flip_h = false
		DIRECTION.RIGHT:
			$Head.flip_h = true
			$UpperBody.flip_h = true
			$LowerBody.flip_h = true

func play_animation():
	match _direction:
		DIRECTION.LEFT:
			$Head.play("left")
			$UpperBody.play("left")
			$LowerBody.play("left")
		DIRECTION.RIGHT:
			$Head.play("right")
			$UpperBody.play("right")
			$LowerBody.play("right")
		_:
			$Head.play("idle")
			$UpperBody.play("idle")
			$LowerBody.play("idle")

func start_moving(direction):
	velocity = Vector2()
	_direction = direction
	match direction:
		DIRECTION.LEFT:
			flip()
			play_animation()
			velocity.x = -1
		DIRECTION.RIGHT:
			flip()
			play_animation()
			velocity.x = 1
	velocity = velocity * speed

func stop_moving():
	_direction = DIRECTION.NONE
	velocity = Vector2()

func _process(delta):
	position += velocity * delta
