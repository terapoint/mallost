extends Control

var selected_slot: Slot

func _ready():
	Events.connect("add_object_to_inventoty", self, "_on_add_object")
	Events.connect("select_inventory_slot", self, "_on_slot_selected")

func _on_add_object(obj):
	if not obj:
		return
	for slot in $Grid.get_children():
		if slot.is_empty():
			slot.add(obj)
			break

func _on_slot_selected(slot: Slot):
	if selected_slot != slot:
		if selected_slot:
			selected_slot.set_selected(false)
		slot.set_selected(true)
		selected_slot = slot
