extends Area2D

var target: Vector2
var speed: float = 100
var is_being_collected: bool = false

signal gold_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body is Player and not is_being_collected:
		is_being_collected = true
		gold_collected.connect(Callable(body, "handle_collect_gold"), CONNECT_ONE_SHOT)
		# TODO: bounce/towards player animation for a duration
		gold_collected.emit()
		self.queue_free()
		

func set_target(target_position: Vector2):
	target = target_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.lerp(target, speed * delta)
	# print(position)
	pass
