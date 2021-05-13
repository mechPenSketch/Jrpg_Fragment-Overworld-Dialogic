extends Node

class_name Controller, "game_controller_icon.svg"

signal action
signal sig_dir

func _input(event):
	
	# ACTION
	if event.is_action_pressed("ui_accept"):
		emit_signal("action")
	else:
	
		# DIRECTION
		var direction = Vector2()
			
		if event.is_action_pressed("ui_up", true):
			direction.y -= 1
		elif event.is_action_pressed("ui_down", true):
			direction.y += 1
		elif event.is_action_pressed("ui_left", true):
			direction.x -= 1
		elif event.is_action_pressed("ui_right", true):
			direction.x += 1
		
		if direction != Vector2(0, 0):
			emit_signal("sig_dir", direction)
