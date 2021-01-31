extends "res://mobs/Mob.gd"
class_name Client

const SELECTION_SCALE = Vector2(1.2, 1.2)

var object_id
var drop_position_x = 0
var spawner

func init(id, spawn, obj_id = null):
	randomize()
	object_id = obj_id
	spawner = spawn
	var animations = GameManager.get_animations(id)
	$Head.frames = animations[GameManager.KEY_PARTS.HEAD]
	$UpperBody.frames = animations[GameManager.KEY_PARTS.UPPER_BODY]
	$LowerBody.frames = animations[GameManager.KEY_PARTS.LOWER_BODY]

func _ready():
	if object_id != null and direction == Constants.DIRECTIONS.RIGHT:
		var random = rand_range(0.1, 0.7)
		drop_position_x = random * Constants.SCREEN_SIZE.x

func _process(delta):
	if object_id != null and drop_position_x > 0 and position.x > drop_position_x:
		Events.emit_signal("on_object_dropped", object_id, self)
		object_id = null

func is_idle() -> bool:
	return state == STATE.IDLE

func stop():
	stop_moving()
	$Popup.alert()

func show_what():
	$Popup.question()

func give(obj: Obj):
	if obj.id == object_id:
		Utils.reparent(obj)
		$Popup.object(obj)
	else:
		$Popup.no()
	start_moving(direction)

func _on_Client_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("ui_touch") \
		and direction == Constants.DIRECTIONS.LEFT \
		and state != STATE.IDLE:
		Events.emit_signal("on_mob_clicked", self)

func _on_Client_mouse_entered():
	if direction == Constants.DIRECTIONS.LEFT:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		scale = SELECTION_SCALE

func _on_Client_mouse_exited():
	if direction == Constants.DIRECTIONS.LEFT:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		scale = Vector2.ONE
