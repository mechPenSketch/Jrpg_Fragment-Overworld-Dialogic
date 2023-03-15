@icon("playing_piece.svg")
extends Sprite2D
class_name PlayingPiece

@export var timeline: String

var move_duration = 0.8

@export_category("Expansion")
@export var expands_symmetrically: bool = true
@export var expands: Vector2


func move_piece(v2i: Vector2i):
	var map_pos = get_parent().local_to_map(get_position())
	map_pos += v2i
	var final_pos = get_parent().map_to_local(map_pos)
	
	var tween = create_tween()
	tween.tween_property(self, "position", final_pos, move_duration)
