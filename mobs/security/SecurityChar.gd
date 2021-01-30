extends Character
class_name SecurityChar

var obj

func _on_SecurityChar_area_entered(area):
	if area is Obj:
		obj = area
		Utils.reparent(obj)
