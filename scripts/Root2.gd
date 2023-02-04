extends Sprite

var player = null
var connected = true

func _ready():
	rotation = 0
	rotation = get_angle_to(player.global_position)
	get_parent().move_child(self, 1)

func _process(_delta):
	if connected:
		visible = true
		rotation = 0
		rotation = get_angle_to(player.global_position)
