extends KinematicBody2D

onready var Root = preload("res://Root.tscn")

const SPEED = 150

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
	velocity = velocity.normalized() * SPEED
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		var root = Root.instance()
		add_child(root)
		root.shoot_to(get_global_mouse_position())
		
