extends Node

class_name ActionManager

var state = 0
enum {NORM, DIALOG, CHOICES}

var current_event
var current_event_as
var action_index

export(NodePath) var np_dialog
var dialog
var dialog_text

export(String, FILE, "*.tscn") var fp_choice_item
var choice_item
export(NodePath) var np_choices_container
var choices_container

func _ready():
	dialog = get_node(np_dialog)
	dialog_text = dialog.find_node("Text")
	
	choice_item = load(fp_choice_item)
	choices_container = get_node(np_choices_container)

func _onto_next_action():
	if action_index < current_event_as.size() - 1:
		jump_to_action(action_index + 1)
	else:
		end_action()

func _on_choice_pressed(i):
	var jump_target = current_event_as[action_index]["choices"][i]["jump_target"]
	var target_line
	
	if current_event.jump_targets.has(jump_target):
		target_line = current_event.jump_targets[jump_target]
	else:
		target_line = int(jump_target)
		
	jump_to_action(target_line)

func _process(_d):
	match state:
		CHOICES:
			choices_container.get_child(0).grab_focus()
			for i in choices_container.get_child_count():
				choices_container.get_child(i).connect("pressed", self, "_on_choice_pressed", [i])
			
	set_process(false)

func activate_state():
	# PAUSING GAME DEPENDING ON STATES
	get_tree().paused = state in [DIALOG, CHOICES]
	
	match state:
		DIALOG:
			dialog.show()
	
	if state in [CHOICES]:
		set_process(true)

func change_state(new_state):
	if state != new_state:
		deactivate_state()
		state = new_state
		activate_state()

func deactivate_state():
	match state:
		DIALOG:
			dialog.hide()
		CHOICES:
			for c in choices_container.get_children():
				choices_container.remove_child(c)
				c.queue_free()

func end_action():
	change_state(NORM)

func initiate_action_sequence(e, i):
	current_event = e
	current_event_as = e.action_sequences
	action_index = i
	
	perform_action()

func jump_to_action(tl):
	action_index = tl
	perform_action()

func perform_action():
	# GET ACTION: DICTIONARY
	var ad = current_event_as[action_index]
	match ad["action_type"]:
		"Text":
			set_dialog(ad["default_text"])
			
		"Choices":
			
			for i in ad["choices"].size():
				var choice_dict = ad["choices"][i]
				var new_choice = choice_item.instance()
				new_choice.set_text(choice_dict["text"])
				choices_container.add_child(new_choice)
					
			change_state(CHOICES)
		
		"Jump":
			var target = ad["target"]
			
			var target_line
			var event_jt = current_event.jump_targets
			if event_jt.has(target):
				target_line = event_jt[target]
			else:
				target_line = int(target)
			
			jump_to_action(target_line)
		
		"Label":
			_onto_next_action()
			
		_:
			# END
			end_action()

func set_dialog(txt):
	dialog_text.set_text(txt)
	change_state(DIALOG)
