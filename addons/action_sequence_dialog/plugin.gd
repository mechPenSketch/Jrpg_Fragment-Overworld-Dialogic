tool
extends EditorPlugin

var editor_selection
var editor_settings

var dock
const ACTION_WINDOW_FOLDER = "res://addons/action_sequence_dialog/action_window/"
const EXT_SCENE = ".tscn"
var dict_file_windows = {}
var action_list
var size_digits
var add_action
var btn_container

var selected_node
var as_property
const ERR_MISSING_PROPERTY = 3
const ERR_WRONG_HINT = 2

var main_font_size

func _enter_tree():
	var editor_interface = get_editor_interface()
	
	# DEFINE MAIN FONT SIZE
	var editor_settings = editor_interface.get_editor_settings()
	main_font_size = editor_settings.get_setting("interface/editor/main_font_size")
	editor_settings.connect("settings_changed", self, "_on_settings_changed")
	
	# SELECTIONS
	editor_selection = editor_interface.get_selection()
	editor_selection.connect("selection_changed", self, "_on_selection_changed")
	
	# ADD TO DOCK
	dock = load("res://addons/action_sequence_dialog/Dock.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)
	switch_dock_display(false)
	action_list = dock.find_node("List")
	
	#	GET [ADD ACTIONS]
	add_action = action_list.get_node("AddActions")
	#		CONNECTING BUTTONS IN [ADD ACTIONS]
	btn_container = add_action.get_child(0)
	for b in btn_container.get_children():
		b.connect("pressed", self, "_on_aabtn_pressed", [b.get_name()])

func _exit_tree():
	# DISCONNECTING BUTTONS IN [ADD ACTIONS]
	for b in btn_container.get_children():
		b.disconnect("pressed", self, "_on_aabtn_pressed")
	
	# REMOVE FROM DOCK
	remove_control_from_docks(dock)
	dock.free()
	
	editor_selection.disconnect("selection_changed", self, "_on_selection_changed")
	editor_settings.disconnect("settings_changed", self, "_on_settings_changed")

func _on_selection_changed():
	
	selected_node = null
	
	# CLEAR LIST IN DOCK
	for c in action_list.get_children():
		if c != add_action:
			c.queue_free()
		else:
			break
	
	for n in editor_selection.get_selected_nodes():
		if n.has_meta("as_property"):
			var str_property = n.get_meta("as_property")
			var dic_property
			for p in n.get_property_list():
				if p.name == str_property:
					dic_property = p
					break
			
			# TARGETTED PROPERTY SHOULD HAVE:
			#	THE USAGE THAT, IN ADDITION TO DEFAULT SETTINGS,
			#		SOULD BE STORABLE (usage: 8199)
			#	THE EXPORT HINT OF ARRAY (hint: 24) FOLLOWED BY
			#		DICTIONARY (hint_string: "18:")
			if dic_property:
				if dic_property['usage'] == 8199 and dic_property['hint'] == 24 and dic_property['hint_string'] == "18:":
					selected_node = n
					as_property = n.get(n.get_meta("as_property"))
					switch_dock_display(true)
					
					# ADD ACTIONS TO LIST
					var action_count = 0 if as_property == null else as_property.size()
					#	DEFINE NUMBER OF DIGITS IN COUNT
					size_digits = String(action_count).length()
					for i in action_count:
						add_action_window(i, size_digits)
						
				else:
					switch_dock_display(ERR_WRONG_HINT)
				return
			else:
				switch_dock_display(ERR_MISSING_PROPERTY)
				return
	
	switch_dock_display(false)
	
func _on_settings_changed():
	main_font_size = editor_settings.get_setting("interface/editor/main_font_size")

func _on_aabtn_pressed(n:String):
	# ADD AN ACTION FROM THE DOCK
	var i
	if as_property == null:
		as_property = []
		i = 0
	else:
		i = as_property.size()
	
	as_property.append({"action_type": n})
	
	add_action_window(i)
	
	# UPDATE PROPERTY LIST
	selected_node.property_list_changed_notify()

func _on_acbtn_pressed(btn, fil):
	# ADDS NEW CHOICE TO THE CHOICES ACTION WINDOW
	# INPUT: ORIGINAL BUTTON, FILE TO CHOICE COMPONENET
	
	#	DICTIONARY
	var i = get_aw_parent(btn).get_index()
	var dict = as_property[i]
	var key = "choices"
	var new_choice_dict = {}
	if dict.has(key):
		dict[key].append(new_choice_dict)
	else:
		dict[key] = [new_choice_dict]
	
	#	NEW INSTANCE
	var choice = fil.instance()
	
	#	INTERFACE
	#		ADD CHOICE BUTTON
	var parent = btn.get_parent()
	parent.add_child(choice)
	
	#		CONNECT FROM EDITOR PLUGIN
	choice.mass_connect(self, new_choice_dict)
	
	#		CHANGE HEADER
	#			GET INDEX
	var new_index = dict[key].find(new_choice_dict)
	choice.set_index(new_index)
	
	#		MOVE CHOICE ABOVE BUTTON
	parent.move_child(choice, btn.get_index())

func _on_action_window_close_pressed(w):
	# INPUT: ACTION WINDOW
	
	# GET INDEX
	var i = w.get_index()
	
	# REMOVE WINDOW
	action_list.remove_child(w)
	w.queue_free()
	
	# ALSO REMOVE DICTIONARY FROM ARRAY
	as_property.remove(i)
	#	UPDATE PROPERTY LIST
	selected_node.property_list_changed_notify()
	
	# RESETTING ACTION INDEX LABELS FOR ALL ENTRIES AFTER IT
	for j in range(i, as_property.size()):
		var str_j = String(j)

func _on_choice_close_pressed(c):
	# INPUT: CHOICE FROM CHOICE WINDOW
	
	# GET CHOICE INDEX
	#	INDEX OF CHOICE DICT FROM ARRAY OF CHOICES
	var cid = c.get_index_from_dict()
	#	INDEX OF CHILDNODE CHOICE FROM CHOICES WINDOW
	var ciw = c.get_index()
	
	# REMOVE FROM CHOICE WINDOW
	var parent = c.get_parent()
	#	GET CHOICE WINDOW BEFORE REMOVAL
	var w = get_aw_parent(c)
	parent.remove_child(c)
	c.queue_free()
	
	# ALSO REMOVE DICTIONARY FROM ARRAY
	#	GET WINDOW INDEX
	#		INDEX OF CHOICE WINDOW FROM DOCK
	var wi = w.get_index()
	#	GET CHOICES
	var choices = as_property[wi]["choices"]
	choices.remove(cid)
	#	UPDATE PROPERTY LIST
	selected_node.property_list_changed_notify()
	
	# FINALLY, RESETTING INDEXES FOR SUBSEQUENT CHOICES
	#	FIND DIFFERENCE BETWEEN INDEXES
	var diff = ciw - cid
	for i in range(ciw, parent.get_child_count()):
		if parent.get_child(i) is SubChoice:
			parent.get_child(i).set_index(i - diff)
		else:
			break

func _on_defualt_text_changed(te):
	var i = get_aw_parent(te).get_index()
	var dict = as_property[i]
	var text = te.get_text()
	var key = "default_text"
	
	set_text(dict, text, key)

func _on_le_changed(text, le):
	var i = get_aw_parent(le).get_index()
	var dict = as_property[i]
	var key = le.associated_key
	
	set_text(dict, text, key)

func _on_le_in_choice_changed(text, le):
	var i = get_aw_parent(le).get_index()
	var dict = as_property[i]
	var ci = get_subchoice_parent(le).get_index_from_dict()
	var key = le.associated_key
	
	set_text(dict["choices"][ci], text, key)

func add_action_window(i, d=0):
	var action = as_property[i]
	var a_name = action["action_type"]
	
	if !a_name in dict_file_windows:
		var file_path = ACTION_WINDOW_FOLDER + a_name + EXT_SCENE
		dict_file_windows[a_name] = load(file_path)
	
	var window = dict_file_windows[a_name].instance()
	action_list.add_child(window)
	
	# SET ACTION INDEX LEBELS
	var str_i = String(i)
	if d < str_i.length(): d = str_i.length()
	window.find_node("Number").set_text(str_i.pad_zeros(d))
	
	# CONNECTING SIGNALS AND SETTING SUB-CONTENT
	window.mass_connect(self, action)
	
	action_list.move_child(window, i)

func get_aw_parent(nd):
	return nd.find_parent("MarginContainer").get_parent()

func get_subchoice_parent(nd):
	return nd.get_parent().get_parent()

func get_standard_textedit_height():
	# TEXTEDIT'S MIN HEIGHT SHOULD BE 3 TIMES THE FONT SIZE
	#	1pt = 1.33px
	#	3pt = 4px
	#	1 LINE HEIGHT = x1.5 THE FONT SOZE
	return main_font_size * 6
	
func set_text(dict, text, key):
	if text == "":
		if dict.has(key):
			dict.erase(key)
			selected_node.property_list_changed_notify()
	else:
		dict[key] = text
		selected_node.property_list_changed_notify()

func switch_dock_display(v):
	var i
	if v is int:
		i = v
	else:
		i = int(v)
	
	for j in dock.get_child_count():
		dock.get_child(j).set_visible(j == i)
