@tool
extends DialogicEvent

func _init()-> void:
	event_name = "Warp"
	set_default_color("Color3")
	event_category = "Overworld"


func _execute()-> void:
	GlobalOverworld.goto_map()
	finish()


func get_shortcode()-> String:
	return "warp"
