extends PlayingPiece

enum {DIR_DOWN, DIR_RIGHT, DIR_UP, DIR_LEFT}
@export var is_symmetrical: bool
@export var dir_frm: int:
	get = get_dir_frm, set = set_dir_frm
@export var act_frm: int:
	set(value):
		act_frm = value
		set_frame_coords(Vector2i(act_frm, dir_frm))

func get_dir_frm()-> int:
	return dir_frm

func set_dir_frm(value):
	if is_symmetrical:
		if value == DIR_LEFT:
			value = DIR_RIGHT
			set_flip_h(true)
		else:
			set_flip_h(false)
	dir_frm = value
	set_frame_coords(Vector2i(act_frm, dir_frm))
