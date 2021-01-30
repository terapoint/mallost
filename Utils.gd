extends Node

func reparent(node: Node, new_parent: Node=null):
	var old_parent = node.get_parent()
	if old_parent != null:
		old_parent.remove_child(node)
	if new_parent != null:
		new_parent.add_child(node)
