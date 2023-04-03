@tool
extends TileMap

var playpieces_by_mapos: Dictionary


func _on_child_entered_tree(node):
	var map_pos = local_to_map(node.get_position())
	playpieces_by_mapos[map_pos] = node
	
	if Engine.is_editor_hint():
		node.moved.connect(_moved_in_editor)


func _on_child_exiting_tree(node):
	if Engine.is_editor_hint():
		node.moved.disconnect(_moved_in_editor)


func _moved_in_editor(node, v2):
	var mapos = local_to_map(v2)
	var snappos = map_to_local(mapos)
	node.set_position(snappos)


func update_map_pos(playing_piece, old_mapos, new_mapos):
	playpieces_by_mapos.erase(old_mapos)
	playpieces_by_mapos[new_mapos] = playing_piece
