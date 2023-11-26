extends Area2D

var Gold: PackedScene = preload("res://Gold.tscn")

var is_being_digged: bool = false
var digging_time_required: float = 1.2
var cooldown_timer: float = digging_time_required
# refers to the first player digging for now
var digging_player: Player = null

signal player_starts_digging
signal digging_completed

# [DEFER] when other players dig too

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_being_digged:
		cooldown_timer -= delta
		$Progress.value = (digging_time_required - cooldown_timer) / digging_time_required * 100
		play_digging_sound()
	if cooldown_timer <= 0.0:
		print("digging completed")
		# spawn a Gold towards the direction of Player (the first digging Player for now)
		spawn_gold_towards_player(digging_player)
		self.queue_free()

func _on_body_entered(body):
	if body is Player:
		# connect player actions
		if not body.dig_action.is_connected(Callable(self, "handle_dig_action")):
			body.dig_action.connect(Callable(self, "handle_dig_action"))
		if not body.dig_interrupted.is_connected(Callable(self, "_on_digging_interrupted")):
			body.dig_interrupted.connect(Callable(self, "_on_digging_interrupted"))

		# connect signal to player
		if not self.player_starts_digging.is_connected(Callable(body, "_handle_digging")):
			self.player_starts_digging.connect(Callable(body, "_handle_digging"))
		if not self.digging_completed.is_connected(Callable(body, "_handle_digging_completed")):
			self.digging_completed.connect(Callable(body, "_handle_digging_completed"))
		# print("connected!")

func _on_body_exited(body):
	if body is Player:
		body.dig_action.disconnect(Callable(self, "handle_dig_action"))
		body.dig_interrupted.disconnect(Callable(self, "_on_digging_interrupted"))
		self.player_starts_digging.disconnect(Callable(body, "_handle_digging"))
		self.player_starts_digging.disconnect(Callable(body, "_handle_digging_completed"))
		# print("disconnected!")

func handle_dig_action(player):
	if not is_being_digged:
		digging_player = player
		is_being_digged = true
		# print("Received & Digging!!!")
		$Progress.show()
		# emit start digging to player
		self.player_starts_digging.emit()
		# to check for 1) movement 2) player got hit
		# so we can fire _on_digging_interrupted accordingly

func _on_digging_interrupted(_player: Player):
	print("digging interrupted")
	is_being_digged = false
	pass

func spawn_gold_towards_player(player: Player):
	var gold = Gold.instantiate()
	print(global_position)
	print(player.global_position)
	get_parent().add_child(gold)
	gold.global_position = global_position # Start at Diggable's position
	gold.set_target(player.global_position)

func play_digging_sound():
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
