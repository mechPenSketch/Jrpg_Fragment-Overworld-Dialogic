@icon("playing_piece.svg")
extends Sprite2D
class_name PlayingPiece

@export var timeline: String

@export_category("Expansion")
@export var expand_from_center: bool = true
@export var expands: Vector2
