extends PlayingPiece

enum {DIR_DOWN, DIR_RIGHT, DIR_UP, DIR_LEFT}
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
	get = get_dir_frm, set = set_dir_frm

## Action frame
@export var act_frm: int:
	set(value):
		act_frm = value
		set_frame_coords(Vector2i(act_frm, dir_frm))


func _on_controller_direction(v2i):
	if not walking_in_progress:
		move_piece(v2i)


func get_dir_frm()-> int:
	return dir_frm


func move_piece(v2i: Vector2i):
	turn_piece(v2i)
	$AnimationTree["parameters/Actions/playback"].travel("act_walking")
	super.move_piece(v2i)


func set_dir_frm(value):
	if is_symmetrical:
		if value == DIR_LEFT:
			value = DIR_RIGHT
			set_flip_h(true)
		else:
			set_flip_h(false)
	dir_frm = value
	set_frame_coords(Vector2i(act_frm, dir_frm))


func turn_piece(v2i):
	$AnimationTree["parameters/Directions/playback"].travel(animdir_from_v2i[v2i])
