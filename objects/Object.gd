extends Area2D
class_name Obj

const offset = Vector2(0, 16)
const z_index_offset = 0.5

func init(texture, pos, elevation):
	$Sprite.texture = texture
	position = pos + offset
	z_index = elevation + z_index_offset

func _on_Object_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_touch"):
		print("clicked")
		Events.emit_signal("on_object_clicked", self)
