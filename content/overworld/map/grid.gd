@tool
extends TileMap

var player
var controller
var children_by_mapos: Dictionary

@export var pksc_custom_player: PackedScene


func _ready():
	if not Engine.is_editor_hint() and get_child_count():
		if pksc_custom_player:
			var custom_player = pksc_custom_player.instantiate()
			set_player(custom_player)
		else:
			set_player(GlobalOverworld.player)
			GlobalOverworld.remove_child(player)
		
		var spawn_target
		var spawn_key = GlobalOverworld.spawn_target
		if spawn_key:
			if spawn_key is String:
				spawn_target = get_node(spawn_key)
			else:
				spawn_target = get_child(spawn_key)
		else:
			spawn_target = get_child(0)
		
		spawn_target.spawn_new_piece(player)


func _on_child_entered_tree(node):
	var map_pos = local_to_map(node.get_position())
	append_child_to_mapos(map_pos, node)
	
	if Engine.is_editor_hint():
		node.moved.connect(_moved_in_editor)


func _on_child_exiting_tree(node):
	if Engine.is_editor_hint():
		node.moved.disconnect(_moved_in_editor)


func _on_action_pressed():
	var player_pos = local_to_map(player.get_position())
	
	if player_pos in children_by_mapos and children_by_mapos[player_pos].size() > 1:
		start_dialogic_by_mapos(player_pos, player.Triggers.ACTION_ON_SPOT)
	else:
		var direction = player.get_v2dir()
		var target_pos = player_pos + direction
	
		start_dialogic_by_possible_mapos(target_pos, player.Triggers.ACTION_BY_SIDE)


func _moved_in_editor(node, v2):
	var mapos = local_to_map(v2)
	var snappos = map_to_local(mapos)
	node.set_position(snappos)


func append_child_to_mapos(pos, child):
	if pos in children_by_mapos:
		children_by_mapos[pos].append(child)
	else:
		children_by_mapos[pos] = [child]


func set_player(playpiece):
	player = playpiece
	controller = playpiece.get_node("Controller")
	controller.action.connect(_on_action_pressed)


func start_dialogic_by_mapos(v2: Vector2i, trg):
	var target_piece = children_by_mapos[v2][0]
	
	if target_piece.trigger == trg:
		GlobalOverworld.interracting_with = target_piece
		Dialogic.start(target_piece.timeline)
		get_viewport().set_input_as_handled()
		controller.paused = true


func start_dialogic_by_possible_mapos(v2: Vector2i, trg):
	if v2 in children_by_mapos:
		start_dialogic_by_mapos(v2, trg)


func update_map_pos(playing_piece, old_mapos, new_mapos):
	if children_by_mapos[old_mapos].size() > 1:
		children_by_mapos[old_mapos].erase(playing_piece)
	else:
		children_by_mapos.erase(old_mapos)
	
	append_child_to_mapos(new_mapos, playing_piece)
