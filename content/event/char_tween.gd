extends Tween

export(NodePath) var np_anim_player
var anim_player
export(bool) var step_is_right = true

func _ready():
	anim_player = get_node(np_anim_player)

func connect_into(o):
	connect("tween_completed", o, "_on_tween_completed")

func move_char(c, t_pos):
	interpolate_property(c, "position", c.get_position(), t_pos, 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	start()
	anim_player.play("Right Step" if step_is_right else "Left Step")
	step_is_right = !step_is_right
