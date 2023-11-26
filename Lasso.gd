extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide() #place with function body.
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_2d_area_entered(area):
	print("Lasso HIT!") # Replace with function body.
