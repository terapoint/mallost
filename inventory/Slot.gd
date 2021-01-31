extends Control
class_name Slot

onready var t_selected = preload("res://inventory/SlotSelectedTexture.tres")
onready var t_not_selected = preload("res://inventory/SlotNotSelectedTexture.tres")

var obj
var selected = false
func is_empty():
	return obj == null

func add(item: Obj):
	obj = item
	$Item.texture = obj.get_texture()

func remove():
	var item = obj
	obj = null
	$Item.texture = null
	return item

func set_selected(selected: bool):
	selected = selected
	if selected:
		$Panel.set("custom_styles/panel", t_selected)
	else:
		$Panel.set("custom_styles/panel", t_not_selected)

func _on_Panel_gui_input(event: InputEvent):
	if event.is_action_pressed("ui_touch") and obj != null:
		Events.emit_signal("select_inventory_slot", self)
