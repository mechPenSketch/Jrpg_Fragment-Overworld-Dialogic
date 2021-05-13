tool
extends VBoxContainer

class_name SubChoice

var index

signal connect_to_editor

func get_index_from_dict()->int:
	return index

func mass_connect(ep, d):
	# INPUT: EDITOR PLUGIN, DICTIONARY OF A CHOICE
	
	# HEADER
	find_node("Remove").connect("pressed", ep, "_on_choice_close_pressed", [self])
	
	# SEND EDITOR PLUGIN TO FURTHER COMPONENTS
	#	FOR SIGNAL CONNECTION
	emit_signal("connect_to_editor", ep, d)

func set_index(i:int):
	index = i
	find_node("Index").set_text("Choice " + String(i))
