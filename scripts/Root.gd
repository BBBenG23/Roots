extends Sprite



func shoot_to(pos):
	var final_scale = scale.x
	scale.x = 0
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(final_scale, scale.y), .15)
	rotation = get_angle_to(pos)
	yield(get_tree().create_timer(.2), "timeout")
	queue_free()
