tool
extends LineEdit

export(String) var associated_key
export(String, "_on_le_changed", "_on_le_in_choice_changed") var signal_call = "_on_le_changed"

func _on_connecting_editor_plugin(ep, d):
	if d.has(associated_key):
		text = d[associated_key]
	
	connect("text_changed", ep, signal_call, [self])
