@icon("controller.svg")
extends Node
class_name Controller

signal action
signal direction(v2i)

var paused: bool

func _ready():
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _input(event):
	if not paused:
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

func _on_timeline_ended():
	paused = false
