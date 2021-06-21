tool
extends Sprite

enum SIDES{
	DOWN,
	RIGHT,
	UP,
	LEFT
}

export(int) var vframes_per_side = 1
export(SIDES) var side setget set_side
export(int) var action_frame setget set_action_frame
export(Vector2) var action_frame_coord setget set_action_frame_coord
export(bool) var is_symmetrical = false

func _on_turning(v):
	match v:
		Vector2(1, 0):
			set_side(SIDES.RIGHT)
		Vector2(-1, 0):
			set_side(SIDES.LEFT)
		Vector2(0, -1):
			set_side(SIDES.UP)
		_:
			set_side(SIDES.DOWN)
	
func set_side(i):
	side = i
	
	# IF THE SPRITE IS SYMMETRICAL,
	#	LEFT IS RIGHT + FLIP HORIZONTAL
	if is_symmetrical:
		if side == SIDES.LEFT:
			side = SIDES.RIGHT
			set_flip_h(true)
		else:
			set_flip_h(false)
	
	calc_frame()

func set_action_frame(i):
	var base = i
	base = clamp_frame(base, vframes_per_side * hframes)
	action_frame = base
	calc_frame()

func set_action_frame_coord(v2):
	var base = v2
	base.x = clamp_frame(base.x, hframes)
	base.y = clamp_frame(base.y, vframes_per_side)
	action_frame_coord = base
	set_action_frame(base.y * get_hframes() + base.x)

func calc_frame():
	frame = hframes * vframes_per_side * side + action_frame

func clamp_frame(frm:int, fexd:int)->int:
	if frm < 0:
		return 0
	elif frm >= fexd:
		return fexd - 1
	return frm
