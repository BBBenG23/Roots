extends KinematicBody2D




func _on_hitbox_area_entered(_area):
	queue_free()
