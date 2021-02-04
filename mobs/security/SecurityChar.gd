extends Character
class_name SecurityChar

const SPEED_MULTIPLIER = 1.2

var obj
var mob_to_stop

func init(item, mob = null):
	obj = item
	mob_to_stop = mob

func set_speed(value):
	speed = value * SPEED_MULTIPLIER

func _on_SecurityChar_area_entered(area):
	if area == obj:
		Utils.reparent(obj)
		stop_moving()
		$Timer.start()
		$Popup.object(obj)
	if area == mob_to_stop:
		stop_moving()
		$Popup.object(obj)
		if area.give(obj):
			obj = null
		$Timer.start()

func _on_Timer_timeout():
	Events.emit_signal("add_object_to_inventoty", obj)
	start_moving(Constants.DIRECTIONS.LEFT)
