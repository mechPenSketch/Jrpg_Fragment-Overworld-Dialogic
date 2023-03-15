@icon("controller.svg")
extends Node
class_name Controller

signal action
signal direction(v2i)

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
				var dir = Vector2i()
					
				if event.is_action_pressed("ui_up", true):
					dir.y -= 1
				elif event.is_action_pressed("ui_down", true):
					dir.y += 1
				elif event.is_action_pressed("ui_left", true):
					dir.x -= 1
				elif event.is_action_pressed("ui_right", true):
					dir.x += 1
				
				if dir != Vector2i(0, 0):
					direction.emit(dir)
		
		DIALOG_JUST_FINISHED:
			if event.is_action_pressed("ui_accept") and !event.is_echo():
				current_mode = NORMAL

func _end_of_dialog(_n):
	current_mode = DIALOG_JUST_FINISHED
