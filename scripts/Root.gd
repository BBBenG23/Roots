extends Sprite

var player
onready var Root2 = load("res://Root2.tscn")

func _ready():
	player = get_parent()
	player.move_child(self, 0)

func shoot_to(pos):
	var final_scale = scale.x
	scale.x = 0
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(final_scale, scale.y), .15)
	rotation = get_angle_to(pos)
	yield(get_tree().create_timer(.2), "timeout")
	var map = player.get_parent()
	var new_root = Root2.instance()
	new_root.player = player
	new_root.rotation = 0
	new_root.rotation = get_angle_to(player.global_position)
	new_root.visible = false
	map.add_child(new_root)
	player.root = new_root
	new_root.global_position = $Point.global_position
	queue_free()
