@icon("controller.svg")
class_name Controller extends Node

## A [Node] dedicated to game controls for a [PlayingPiece].

## Emitted when the action button is pressed.
signal action

## Emitted when a directional input is pressed.
signal direction(v2i)

## The pause status of the game.
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


## To be called when the Dialogic timeline
## finishes.
func _on_timeline_ended():
	paused = false
