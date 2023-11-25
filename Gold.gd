extends Area2D

var target: Vector2
var speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_target(target_position: Vector2):
	target = target_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.lerp(target, speed * delta)
	# print(position)
	pass
