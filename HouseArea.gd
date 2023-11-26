extends Area2D

signal reached_house

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))


func _on_body_entered(body):
	if body is Player:
		# connect signal to player
		if not self.reached_house.is_connected(Callable(body, "_handle_deliver_gold")):
			self.reached_house.connect(Callable(body, "_handle_deliver_gold"))
		reached_house.emit()

func _on_body_exited(body):
	if body is Player:
		self.reached_house.disconnect(Callable(body, "_handle_deliver_gold"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
