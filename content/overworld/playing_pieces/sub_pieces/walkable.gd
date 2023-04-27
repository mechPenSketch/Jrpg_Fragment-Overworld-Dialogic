@tool
extends PlayingPiece

enum {
	DIR_DOWN,
	DIR_RIGHT,
	DIR_UP,
	DIR_LEFT,
}

var animdir_from_v2i: Dictionary = {
	Vector2i(-1, 0): "dir_left",
	Vector2i(1, 0): "dir_right",
	Vector2i(0, -1): "dir_up",
	Vector2i(0, 1): "dir_down"
}

## Checks whether sprite texture is symmetrical
@export var is_symmetrical: bool

## Directional frame
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

## Action frame co-ordinates
@export var act_frm_coords: Vector2i:
	set(value):
		act_frm_coords = value
		calculate_frame_coords()


func _on_controller_direction(v2i):
	if not walking_in_progress:
		move_piece(v2i)


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


func move_piece(v2i: Vector2i):
	turn_piece(v2i)
	$AnimationTree["parameters/Actions/playback"].travel("act_walking")
	super.move_piece(v2i)


func calculate_frame_coords():
	var final_value = act_frm_coords
	final_value += Vector2i(0, dir_frm * vframes_per_dir)
	set_frame_coords(final_value)


func turn_piece(v2i):
	$AnimationTree["parameters/Directions/playback"].travel(animdir_from_v2i[v2i])
