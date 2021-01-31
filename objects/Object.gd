extends Area2D
class_name Obj

enum GROW {UP, DOWN}

const offset = Vector2(0, 16)
const down_scale = Vector2(0.8, 0.8)
const up_scale = Vector2(1.2, 1.2)

var state = GROW.UP
var spawner
var id

func _animate():
	var start
	var end
	match state:
		GROW.UP:
			start = down_scale
			end = up_scale
		GROW.DOWN:
			start = up_scale
			end = down_scale
	$Tween.interpolate_property(
		self, "scale",
		start, end, 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.start()

func _ready():
	_animate()
	
func init(obj_id, texture, pos, spawn):
	id = obj_id
	$Sprite.texture = texture
	position = pos + offset
	spawner = spawn
	spawner.add_object(self)

func get_texture() -> Texture:
	return $Sprite.texture

func _on_Object_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("ui_touch"):
		Events.emit_signal("on_object_clicked", self)

func _on_Tween_tween_completed(_object, _key):
	match state:
		GROW.UP:
			state = GROW.DOWN
		GROW.DOWN:
			state = GROW.UP
	_animate()


func _on_Object_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_Object_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
