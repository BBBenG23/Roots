extends KinematicBody2D


var speed = 50

func _on_hitbox_area_entered(_area):
	queue_free()

func _physics_process(_delta):
	var velocity = (Global.player.global_position - global_position).normalized()
	move_and_slide(velocity * speed)
