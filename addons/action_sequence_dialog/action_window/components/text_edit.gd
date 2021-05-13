tool
extends TextEdit

func _on_connecting_editor_plugin(ep, d):
	if d.has("default_text"):
		text = d["default_text"]
	
	connect("text_changed", ep, "_on_defualt_text_changed", [self])
