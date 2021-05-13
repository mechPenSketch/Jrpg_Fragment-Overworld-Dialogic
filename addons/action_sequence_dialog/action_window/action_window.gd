tool
extends PanelContainer

signal connect_to_editor

func mass_connect(ep, d):
	# INPUT: EDITOR PLUGIN, DICTIONARY OF AN ACTION
	
	# HEADER
	find_node("Remove").connect("pressed", ep, "_on_action_window_close_pressed", [self])
	
	# SEND EDITOR PLUGIN TO FURTHER COMPONENTS
	#	FOR SIGNAL CONNECTION
	emit_signal("connect_to_editor", ep, d)
