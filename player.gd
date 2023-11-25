extends Area2D

var x_direction = 1
var current_animation = null
var animation : AnimationPlayer

func _ready():
	screen_size = get_viewport_rect().size
	animation = $Sprites/AnimationPlayer

	# Play the idle animation when the scene starts
	animation.play("IdleRight")

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _input(InputEvent):
	# listen to SPACEBAR (for weapon)
	if Input.is_action_just_pressed("ui_accept"):
		print("space pressed")
		use_weapon()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		if (x_direction != 1):
			x_direction = 1;
			$Sprites.scale = Vector2(1, 1);
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		if (x_direction != -1):
			x_direction = -1;
			$Sprites.scale = Vector2(-1, 1);
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		if (x_direction != -1):
			x_direction = -1;
			$Sprites.scale = Vector2(-1,1)
	if Input.is_action_pressed("move_up"):
		if (x_direction != 1):
			x_direction = 1;
			$Sprites.scale = Vector2(1,1)
		velocity.y -= 1


	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animation.play("WalkingRight")
		#$AnimatedSprite2D.animation = "walking"
	else:
		animation.play("IdleRight")
		#$AnimatedSprite2D.play()
	var isometric_velocity = Vector2(
		velocity.x - velocity.y,
		(velocity.x + velocity.y) / 2
	)

#	position += velocity * delta
	position += isometric_velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	update_cooldown(delta)


var weapon_cooldown_duration = 3.0
var cooldown_timer = 0.0

func use_weapon():
	if cooldown_timer <= 0:
		# TODO: Use weapon, do things to its UI etc
		start_cooldown()
	else:
		# TODO: Play weapon disabled sound
		print("Weapon is on cooldown")


func start_cooldown():
	cooldown_timer = weapon_cooldown_duration
	$Cooldown.show()
	$Cooldown.value = 0.0

func update_cooldown(delta):
	# update cooldown timer & cooldown bar
	if cooldown_timer > 0:
		cooldown_timer -= delta
		$Cooldown.value = (weapon_cooldown_duration - cooldown_timer) / weapon_cooldown_duration * 100

		if cooldown_timer <= 0:
			on_cooldown_finished()

func on_cooldown_finished():
	$Cooldown.hide()
	cooldown_timer = 0.0
