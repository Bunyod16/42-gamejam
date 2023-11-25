extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	if body is Player:
		if body.dig_action.is_connected(Callable(self, "handle_dig")):
			return
		body.dig_action.connect(Callable(self, "handle_dig"))
		# print("connected!")

func _on_body_exited(body):
	if body is Player:
		body.dig_action.disconnect(Callable(self, "handle_dig"))
		# print("disconnected!")

func handle_dig(_player):
	print("Received & Digging!!!")
	pass
