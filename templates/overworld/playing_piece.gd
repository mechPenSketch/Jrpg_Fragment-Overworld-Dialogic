@icon("playing_piece.svg")
extends Sprite2D
class_name PlayingPiece

@export var timeline: String

var move_duration = 0.8

@export_category("Expansion")
@export var blocks_path: bool = true
@export var expands: Vector2
@export var symmetrically: bool = true


func move_piece(v2i: Vector2i):
	var map_pos = get_parent().local_to_map(get_position())
	map_pos += v2i
	
	if not is_blocked(map_pos):
		var final_pos = get_parent().map_to_local(map_pos)
	
		var tween = create_tween()
		tween.tween_property(self, "position", final_pos, move_duration)


func is_blocked(map_pos)-> bool:
	return is_blocked_by_playing_piece(map_pos) or is_blocked_by_terrain(map_pos)


func is_blocked_by_playing_piece(map_pos):
	return false


func is_blocked_by_terrain(map_pos)-> bool:
	var tiledata = get_parent().get_cell_tile_data(1, map_pos)
	if tiledata:
		return tiledata.get_terrain_set() != 0
	else:
		return false

