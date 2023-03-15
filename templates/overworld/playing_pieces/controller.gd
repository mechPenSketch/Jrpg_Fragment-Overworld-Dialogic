@icon("controller.svg")
extends Node
class_name Controller

signal action
signal sig_dir(v2i)

enum {NORMAL, DIALOG, DIALOG_JUST_FINISHED}
var current_mode = NORMAL

func _input(event):
	match current_mode:
		NORMAL:
			# ACTION
			if event.is_action_pressed("ui_accept") and !event.is_echo():
				action.emit()
			else:

				# DIRECTION
				var direction = Vector2i()
					
				if event.is_action_pressed("ui_up", true):
					direction.y -= 1
				elif event.is_action_pressed("ui_down", true):
					direction.y += 1
				elif event.is_action_pressed("ui_left", true):
					direction.x -= 1
				elif event.is_action_pressed("ui_right", true):
					direction.x += 1
				
				if direction != Vector2i(0, 0):
					sig_dir.emit(direction)
		
		DIALOG_JUST_FINISHED:
			if event.is_action_pressed("ui_accept") and !event.is_echo():
				current_mode = NORMAL

func _end_of_dialog(_n):
	current_mode = DIALOG_JUST_FINISHED
