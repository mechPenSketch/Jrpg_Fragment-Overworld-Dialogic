@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join("event_warp.gd")]


func _get_subsystems() -> Array:
	return [{'name':'Overworld', 'script':this_folder.path_join('subsystem_overworld.gd')}]
