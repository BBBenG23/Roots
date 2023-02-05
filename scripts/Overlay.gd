extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Overlay = self
#	$Gameover.visible = false
#	$Good_ending.visible = false
#	$Bad_ending.visible = false

func game_over():
	$Gameover.visible = true

func good_ending():
	$Good_ending.visible = true

func bad_ending():
	$Bad_ending.visible = true
