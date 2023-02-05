extends KinematicBody2D

onready var Root = preload("res://Root.tscn")

export var speed : int
export var max_water : int 
export var max_health : int
var water : int
var health : int
var root = null
var shooting = false
var being_eaten = false
var shocked = false
var ouch = false
var wiggling = false
var parasite = false

func _ready():
	$Sprite.region_rect = Rect2(1572, 104, 148, 300)
	water = max_water
	health = max_health
	Global.player = self

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("w"):
		velocity += Vector2.UP
	if Input.is_action_pressed("a"):
		velocity += Vector2.LEFT
		$Sprite.flip_h = true
	if Input.is_action_pressed("s"):
		velocity += Vector2.DOWN
	if Input.is_action_pressed("d"):
		velocity += Vector2.RIGHT
		$Sprite.flip_h = false
	velocity = velocity.normalized()
	if root != null and !shooting:
		var point = root.get_node("Point")
		var dir = (global_position - point.global_position).normalized()
		var parallel = dir.dot(velocity) * dir
		velocity -= parallel
	
	if velocity != Vector2.ZERO and !wiggling:
		wiggling = true
		yield(get_tree().create_timer(.2), "timeout")
		rotation_degrees = 5
		yield(get_tree().create_timer(.2), "timeout")
		rotation_degrees = -5
		yield(get_tree().create_timer(.2), "timeout")
		rotation_degrees = 0
		wiggling = false
	
	if !ouch:
		if being_eaten or shocked:
			ouch = true
			yield(get_tree().create_timer(.2), "timeout")
			if being_eaten:
				change_health(-5)
			if shocked:
				change_health(-5)
			ouch = false
	
		
	# warning-ignore:return_value_discarded
	move_and_slide(velocity * speed)

func _process(_delta):
	check_win()
	var overlaps = $Hurtbox.get_overlapping_areas()
	shocked = false
	being_eaten = false
	for area in overlaps:
		if area.get_parent().name[0] == "R" or \
				(area.get_parent().name[0] == "@" and area.get_parent().name[1] == "R"):
			if area.get_parent().electric:
				shocked = true
		if area.get_parent() is Bunny:
			being_eaten = true

func _input(event):
	if event.is_action_pressed("click"):
		if root == null:
			change_water(-15)
			shooting = true
			root = Root.instance()
			add_child(root)
			root.shoot_to(get_global_mouse_position())
		elif root != null and !shooting:
			root.connected = false
			root = null

func game_over():
	Global.Overlay.game_over()

func check_win():
	var things = get_parent().get_children()
	for i in things:
		if i is Bunny:
			return
	if parasite:
		Global.Overlay.bad_ending()
	else:
		Global.Overlay.good_ending()

func become_parasite():
	parasite = true
	$Sprite.region_rect = Rect2(1430, 1010, 148, 300)
	

func change_water(amount):
	water += amount
	if water <= 0:
		game_over()
	# warning-ignore:narrowing_conversion
	water = max(min(water, max_water), 0)
	Global.Overlay.get_node("Water_bar").rect_scale.x = float(water) / max_water

func change_health(amount):
	if parasite:
		change_water(amount)
		return
	health += amount
	health = max(min(health, max_health), 0)
	if health == 0:
		become_parasite()
	Global.Overlay.get_node("Health_bar").rect_scale.x = float(health) / max_health

