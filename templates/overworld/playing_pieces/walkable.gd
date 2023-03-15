extends PlayingPiece

enum {DIR_DOWN, DIR_RIGHT, DIR_UP, DIR_LEFT}
var dir_from_v2i: Dictionary = {
	Vector2i(-1, 0): DIR_LEFT,
	Vector2i(1, 0): DIR_RIGHT,
	Vector2i(0, -1): DIR_UP,
	Vector2i(0, 1): DIR_DOWN
}
@export var is_symmetrical: bool
@export var dir_frm: int:
	get = get_dir_frm, set = set_dir_frm
@export var act_frm: int:
	set(value):
		act_frm = value
		set_frame_coords(Vector2i(act_frm, dir_frm))


func _on_controller_direction(v2i):
	move_piece(v2i)


func get_dir_frm()-> int:
	return dir_frm


func move_piece(v2i: Vector2i):
	turn_piece(v2i)
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
	set_dir_frm(dir_from_v2i[v2i])
