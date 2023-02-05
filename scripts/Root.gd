extends Sprite

class_name Root

var player

var connected = false
var wet = false
var charged = false
var electric = false
var drinking = false
var final_scale = scale
var dying = false

func _ready():
	player = get_parent()
	player.move_child(self, 0)
	region_rect = Rect2(135, 910, 180, 65)
	yield(get_tree().create_timer(12), "timeout")
	dying = true
	queue_free()

func shoot_to(pos):
	scale.x = 0
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(final_scale.x, scale.y), .15)
	rotation = get_angle_to(pos)
	yield(get_tree().create_timer(.2), "timeout")
	var map = player.get_parent()
	flip_h = false
	flip_v = true
	player.root = self
	var old_pos = $Point.global_position
	visible = false
	player.remove_child(self)
	map.add_child(self)
	map.move_child(self, 1)
	scale = Vector2.ZERO
	global_position = old_pos
	$Point.global_position = old_pos
	$Point.rotation_degrees = 180
	player.shooting = false
	connected = true

func wet_source(prevs):
	for i in prevs:
		if i.get_parent() == self:
			return false
	var overlaps = $Point.get_overlapping_areas()
	prevs.append(self)
	for area in overlaps:
		if area.get_parent() is Puddle:
			return true
		var already = false
		for i in prevs:
			if area.get_parent() == i:
				 already = true
		if area.get_parent().name[0] == "R" or \
				(area.get_parent().name[0] == "@" and area.get_parent().name[1] == "R"):
			if !already and area.get_parent().wet_source(prevs):
				return true
	return false

func charged_source(prevs):
	for i in prevs:
		if i.get_parent() == self:
			return false
	var overlaps = $Point.get_overlapping_areas()
	prevs.append(self)
	for area in overlaps:
		if area.get_parent() is Battery:
			return true
		var already = false
		for i in prevs:
			if area.get_parent() == i:
				 already = true
		if area.get_parent().name[0] == "R" or \
				(area.get_parent().name[0] == "@" and area.get_parent().name[1] == "R"):
			if !already and area.get_parent().charged_source(prevs):
				return true
	return false
		
func _process(_delta):
	var overlaps = $Point.get_overlapping_areas()
	if wet_source([]):
		make_wet()
	else:
		make_normal()
	if charged_source([]):
		charged = true
	else:
		charged = false
	if wet and charged:
		make_electric()
	elif wet:
		make_wet()
	else:
		make_normal()
	
	if connected:
		scale = final_scale
		visible = true
		rotation = 0
		rotation = get_angle_to(player.global_position)
		if wet and !drinking:
			drinking = true
			yield(get_tree().create_timer(.2), "timeout")
			if connected:
				Global.player.change_water(5)
			drinking = false


func make_wet():
	electric = false
	wet = true
	region_rect = Rect2(135, 1000, 180, 65)

func make_electric():
	electric = true
	region_rect = Rect2(135, 1240, 180, 65)

func make_charged():
	charged = true

func make_normal():
	electric = false
	wet = false
	region_rect = Rect2(135, 910, 180, 65)
