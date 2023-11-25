extends Area2D

var is_being_digged: bool = false
var digging_time_required: float = 1.2
var cooldown_timer: float

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	cooldown_timer = digging_time_required
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_being_digged:
		cooldown_timer -= delta
		$Progress.value = (digging_time_required - cooldown_timer) / digging_time_required * 100
	if cooldown_timer <= 0.0:
		print("digging completed")
		# TODO: spawn a Gold?
		self.queue_free()

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
	if not is_being_digged:
		is_being_digged = true
		print("Received & Digging!!!")
		$Progress.show()
	# emit digging to Player(?)
	# to check for 1) movement 2) player got hit
	# so we can fire on_digging_interrupted accordingly
	
func on_digging_interrupted():
	is_being_digged = false
	pass
