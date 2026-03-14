extends Node

func find_node_in_children(parent, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
		var grandchild = find_node_in_children(child, type)
		if grandchild != null:
			return grandchild
	return null

func get_sibling_by_type(parent, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
