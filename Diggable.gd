extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_entered(area):
	if area is Player: # if it's an Area2D of type Player
		area.dig_action.connect(Callable(self, "handle_dig"), CONNECT_ONE_SHOT)
		print("connected!")

func _on_area_exited(area):
	if area is Player:
		area.dig_action.disconnect(Callable(self, "handle_dig"))
		# print("disconnected!")

func handle_dig(player):
	print("Digging!!!")
	pass
