tool
extends EditorPlugin

var additional_mains = []
const INDEX_AFTER_VIEW = 25
var behind_popups
var pop_add

func _enter_tree():
	
	# ADD TO MAIN TOOLBAR
	#	ADD EVENT
	var add_event = ToolButton.new()
	add_event.set_button_icon(load("res://addons/jrpg_overwolrd/btn_icon.svg"))
	add_event.connect("pressed", self, "_on_add_event_pressed")
	
	additional_mains += [VSeparator.new(), add_event]
	for i in additional_mains.size():
		add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, additional_mains[i])
		additional_mains[i].get_parent().move_child(additional_mains[i], INDEX_AFTER_VIEW + i)
	
	# POPUPS
	#	DEFINE PLACEMENT TO PUT POPUP IN
	behind_popups = get_script_create_dialog().get_parent()
	
	pop_add = load("res://addons/jrpg_overwolrd/Dialog.tscn").instance()
	pop_add.set_as_minsize()
	behind_popups.add_child(pop_add)
	pop_add.connect("confirmed", self, "_on_dialog_confirmed")
	
func _exit_tree():
	# REMOVE POPUP
	behind_popups.remove_child(pop_add)
	pop_add.free()
	
	# REMOVE ADDITIONAL TOOLBAR
	for c in additional_mains:
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, c)
		c.queue_free()

func _on_add_event_pressed():
	pop_add.popup_centered()

func _on_dialog_confirmed():
	
	# GET TARGET NODE TO ADD NEW EVENT TO
	var root = get_tree().get_edited_scene_root()
	var target_parent = root
	for n in get_editor_interface().get_selection().get_selected_nodes():
		if target_parent.is_a_parent_of(n):
			target_parent = n
			break
	
	# GET FILEPATH
	var nd_class = pop_add.find_node("OptionClass")
	var int_class = nd_class.get_selected()
	var txt_class = nd_class.get_item_text(int_class)
	var txt_exp = "Exp" if pop_add.find_node("CheckExp").is_pressed() else ""
	var final_filepath = pop_add.dir + "/" + txt_class + txt_exp + ".tscn"
	
	# GENERATE NEW EVENT
	var inst_event = load(final_filepath).instance()
	
	#	SET PARAMETERS
	#var editor_children = get_tree().get_root().get_node("EditorNode").get_children()
	#var snap_map
	#for c in editor_children:
	#	if c is EditorPlugin and c.get_plugin_name() == "Snap Map":
	#		snap_map = c
	#		break
	
	#if snap_map:
	#	print(snap_map)
	
	#	NAME OF NEW EVENT
	var new_name = pop_add.find_node("EditName").get_text()
	if new_name:
		inst_event.set_name(new_name)
		# CLEAR INPUT
		pop_add.find_node("EditName").clear()
	target_parent.add_child(inst_event)
	inst_event.set_owner(root)
