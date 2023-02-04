extends Sprite

class_name Root

var player

var connected = false
var wet = false
var drinking = false

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
	flip_h = false
	player.root = self
	var old_pos = $Point.global_position
	visible = false
	player.remove_child(self)
	map.add_child(self)
	global_position = old_pos
	player.shooting = false
	connected = true


func _process(_delta):
	if connected:
		visible = true
		rotation = 0
		rotation = get_angle_to(player.global_position)
		if wet and !drinking:
			drinking = true
			yield(get_tree().create_timer(.2), "timeout")
			if connected:
				Global.player.change_water(5)
			drinking = false

func _on_Point_area_entered(area):
	if area.get_parent() is Puddle:
		wet = true
	if area.get_parent().name[0] == "R" or \
			(area.get_parent().name[0] == "@" and area.get_parent().name[1] == "R"):
		if area.get_parent().wet:
			wet = true

func _on_Point_area_exited(area):
	if area.get_parent() is Puddle:
		wet = false
	if area.get_parent().name[0] == "R" or \
			(area.get_parent().name[0] == "@" and area.get_parent().name[1] == "R"):
		if area.get_parent().wet:
			wet = false
