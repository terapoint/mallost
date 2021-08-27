extends "res://mobs/Mob.gd"
class_name Client

const SELECTION_SCALE = Vector2(1.2, 1.2)

var object_id
var drop_position_x = 0
var spawner

func init(id: String, spawn, obj_id = null):
	randomize()
	object_id = obj_id
	spawner = spawn
	var colors = id.split("|", false)
	$Head.material.set_shader_param("REPLACEMENT_COLOR", Color(colors[0]))
	$UpperBody.material.set_shader_param("REPLACEMENT_COLOR", Color(colors[1]))
	$LowerBody.material.set_shader_param("REPLACEMENT_COLOR", Color(colors[2]))

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

func give(obj: Obj) -> bool:
	if obj.id == object_id:
		Utils.reparent(obj)
		$Popup.object(obj)
		return true
	$Popup.no()
	$Timer.start()
	return false

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


func _on_Timer_timeout():
	start_moving(direction)
