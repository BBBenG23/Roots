extends KinematicBody2D

class_name Bunny


export var speed : int

func _on_hitbox_area_entered(area):
	if area.get_parent() is Root:
		if area.get_parent().electric:
			queue_free()
			Global.player.check_win()

func _physics_process(_delta):
	var velocity = (Global.player.global_position - global_position).normalized()
	# warning-ignore:return_value_discarded
	move_and_slide(velocity * speed)
	if velocity.x > 0:
		$Sprite.flip_h = true
	elif velocity.x < 0:
		$Sprite.flip_h = false
