extends Node2D



func _ready():
	OS.center_window()

func _unhandled_input(event):
	if event.is_action_pressed("r"):
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()



var Overlay = null
var player = null
