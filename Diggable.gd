extends Area2D

# var PlayerType = preload("res://Player.gd")

var player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_area_entered(_area):
	print("entered")
	#if area.get_script() == PlayerType:
	#	print("in it")
		
func _on_area_exited(_area):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
