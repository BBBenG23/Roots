extends KinematicBody2D

onready var Root = preload("res://Root.tscn")

export var speed : int
export var max_water : int 
export var max_health : int
var water : int
var health : int
var root = null
var shooting = false

func _ready():
	water = max_water
	health = max_health
	Global.player = self

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("w"):
		velocity += Vector2.UP
	if Input.is_action_pressed("a"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("s"):
		velocity += Vector2.DOWN
	if Input.is_action_pressed("d"):
		velocity += Vector2.RIGHT
	velocity = velocity.normalized()
	if root != null and !shooting:
		var point = root.get_node("Point")
		var dir = (global_position - point.global_position).normalized()
		var parallel = dir.dot(velocity) * dir
		velocity -= parallel
		
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity * speed)

func _input(event):
	if event.is_action_pressed("click"):
		if water >= 10 and root == null:
			shooting = true
			root = Root.instance()
			add_child(root)
			root.shoot_to(get_global_mouse_position())
			change_water(-20)
		elif root != null and !shooting:
			root.connected = false
			root = null

func change_water(amount):
	water += amount
	# warning-ignore:narrowing_conversion
	water = max(min(water, max_water), 0)
	Global.Overlay.get_node("Water_bar").rect_scale.x = float(water) / max_water

func change_health(amount):
	if health < amount:
		return
	health -= amount
	Global.Overlay.get_node("Health_bar").rect_scale.x = float(health) / max_health
