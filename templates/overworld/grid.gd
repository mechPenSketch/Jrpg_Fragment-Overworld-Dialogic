extends TileMap

var playpieces_by_mapos: Dictionary

@export var events_by_playpieces: Dictionary


func _on_child_entered_tree(node):
	var map_pos = local_to_map(node.get_position())
	playpieces_by_mapos[map_pos] = node


func update_map_pos(playing_piece, old_mapos, new_mapos):
	playpieces_by_mapos.erase(old_mapos)
	playpieces_by_mapos[new_mapos] = playing_piece
