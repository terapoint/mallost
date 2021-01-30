extends "res://mobs/Mob.gd"
class_name Client

var object
var viewport_size = Vector2()
var drop_position_x = 0

func _ready():
	if object:
		var random = rand_range(0.1, 0.8)
		drop_position_x = random * Constants.SCREEN_SIZE.x

func init(id, obj = null):
	randomize()
	object = obj
	var animations = GameManager.get_animations(id)
	$Head.frames = animations[GameManager.KEY_PARTS.HEAD]
	$UpperBody.frames = animations[GameManager.KEY_PARTS.UPPER_BODY]
	$LowerBody.frames = animations[GameManager.KEY_PARTS.LOWER_BODY]

func _process(delta):
	._process(delta)
	if object and position.x > drop_position_x:
		Events.emit_signal("on_object_dropped", object, self)
		print("dropping" + str(object))
		object = null
