extends Area2D

func _ready():
	pass


func _on_area_entered(area):
	if area is SecurityChar:
		if area.obj != null:
			Events.emit_signal("add_object_to_inventoty", area.obj)
	if area is Mob:
		Events.emit_signal("on_mob_despawn", area)
	area.queue_free()
