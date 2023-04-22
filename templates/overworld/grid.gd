@tool
extends TileMap

var player
var controller
var playpieces_by_mapos: Dictionary


func _ready():
	set_player($Alice)


func _on_child_entered_tree(node):
	var map_pos = local_to_map(node.get_position())
	playpieces_by_mapos[map_pos] = node
	
	if Engine.is_editor_hint():
		node.moved.connect(_moved_in_editor)


func _on_child_exiting_tree(node):
	if Engine.is_editor_hint():
		node.moved.disconnect(_moved_in_editor)


func _on_action_pressed():
	var player_pos = local_to_map(player.get_position())
	
	#if player_pos in playpieces_by_mapos:
	#	start_dialogic_by_mapos(player_pos, player.Triggers.ACTION_ON_SPOT)
	#else:
	var direction = player.get_v2dir()
	var target_pos = player_pos + direction
	
	start_dialogic_by_possible_mapos(target_pos, player.Triggers.ACTION_BY_SIDE)


func _moved_in_editor(node, v2):
	var mapos = local_to_map(v2)
	var snappos = map_to_local(mapos)
	node.set_position(snappos)


func set_player(playpiece):
	player = playpiece
	controller = playpiece.get_node("Controller")
	controller.action.connect(_on_action_pressed)


func start_dialogic_by_mapos(v2: Vector2i, trg):
	var target_piece = playpieces_by_mapos[v2]
	
	if target_piece.trigger == trg:
		Dialogic.start(target_piece.timeline)
		controller.paused = true


func start_dialogic_by_possible_mapos(v2: Vector2i, trg):
	if v2 in playpieces_by_mapos:
		start_dialogic_by_mapos(v2, trg)


func update_map_pos(playing_piece, old_mapos, new_mapos):
	playpieces_by_mapos.erase(old_mapos)
	playpieces_by_mapos[new_mapos] = playing_piece
