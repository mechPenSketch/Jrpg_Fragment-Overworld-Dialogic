@tool
@icon("walkable.svg")
class_name WalkingPiece extends PlayingPiece

## Typically used for NPCs.

## Directions the piece can move in.
enum {
	DIR_DOWN,
	DIR_RIGHT,
	DIR_UP,
	DIR_LEFT,
}

## Path to an [AnimationNodeStateMachinePlayback]
## for playing an action.
const PLAYBACK_ACTION := "parameters/Actions/playback"

## Path to an [AnimationNodeStateMachinePlayback]
## for playing a direction.
const PLAYBACK_DIR := "parameters/Directions/playback"

## Checks whether sprite texture is symmetrical.
@export var is_symmetrical: bool

## An integer that represents the direction
## to face.
@export var dir_frm: int:
	set(value):
		if is_symmetrical:
			if value == DIR_LEFT:
				value = DIR_RIGHT
				set_flip_h(true)
			else:
				set_flip_h(false)
		dir_frm = value
		calculate_frame_coords()

## Number of rows for each direction in a sprite sheet.
@export_range(1, 2^63-1) var vframes_per_dir: int = 1

## Represents an action frame, in the form of [Vector2i]
## to account for [member vframes_per_dir].
@export var act_frm_coords: Vector2i:
	set(value):
		act_frm_coords = value
		calculate_frame_coords()

## [AnimationNodeStateMachinePlayback]
## for playing an action.
var playback_action

## A dictionary of animation names
## by direction co-ordinates.
var animdir_from_v2i: Dictionary = {
	Vector2i(-1, 0): "dir_left",
	Vector2i(1, 0): "dir_right",
	Vector2i(0, -1): "dir_up",
	Vector2i(0, 1): "dir_down"
}

func _ready():
	super()
	playback_action = $AnimationTree[PLAYBACK_ACTION]


## To be called when a directional button is pressed.
func _on_controller_direction(v2i):
	if not walking_in_progress:
		move_piece(v2i)


## To be called after its action or directional frame
## is set.
func calculate_frame_coords():
	var final_value = act_frm_coords
	final_value += Vector2i(0, dir_frm * vframes_per_dir)
	set_frame_coords(final_value)


func get_v2dir()-> Vector2i:
	match frame_coords.y / vframes_per_dir:
		DIR_RIGHT:
			if is_flipped_h:
				return Vector2i(-1, 0)
			else:
				return Vector2i(1, 0)
		DIR_UP:
			return Vector2i(0, -1)
		DIR_LEFT:
			return Vector2i(-1, 0)
		_:
			return Vector2i(0, 1)


func move_piece(v2i: Vector2i, custom_track := "act_walking"):
	turn_piece(v2i)
	super.move_piece(v2i, custom_track)


func moving_when_blocked(custom_track):
	playback_action.travel(custom_track)


func moving_when_unblocked(custom_track, map_pos, target_mapos):
	playback_action.start(custom_track)
	super.moving_when_unblocked(custom_track, map_pos, target_mapos)


## Changes the facing direction of the piece.
func turn_piece(v2i):
	$AnimationTree[PLAYBACK_DIR].travel(animdir_from_v2i[v2i])
