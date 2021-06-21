extends RichTextLabel

signal finish

var current_state
enum {HIDE, COMPLETE, PROGRESS}

var dvis = 1

func _action():
	match current_state:
		PROGRESS:
			set_percent_visible(1.0)
			change_state(COMPLETE)
		COMPLETE:
			emit_signal("finish")

func _on_dialog_visibility_changed():
	if get_parent().get_parent().is_visible():
		change_state(PROGRESS)
	else:
		change_state(HIDE)

func _process(_d):
	visible_characters += dvis
	
	if visible_characters >= get_total_character_count():
		change_state(COMPLETE)

func _ready():
	set_process(false)

func activate_state():
	match current_state:
		PROGRESS:
			set_process(true)

func change_state(i):
	deactivate_state()
	current_state = i
	activate_state()

func deactivate_state():
	match current_state:
		PROGRESS:
			set_process(false)
