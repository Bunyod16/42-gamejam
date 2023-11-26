extends CharacterBody2D
class_name Player

var x_direction = 1
var current_animation = null
var animation : AnimationPlayer
var on_hand_idle_sprite : Sprite2D
var on_hand_walking_sprite : Sprite2D
var on_hand_attack_sprite : Sprite2D
var is_stunned: bool = false
const stun_duration: float = 0.6
signal shovel_hit

var collected_gold_count: int = 0
var gold_icons: Array = []
const gold_speed_modifier: Array = [1.0, 0.9, 0.77, 0.6]
var is_digging = false

const shovel_texture = preload("res://assets/cowboy/Shovel.png")
const lasso_texture = preload("res://assets/cowboy/Lasso.png")

const solid_gold_texture = preload("res://assets/gold.png")
const outline_gold_texture = preload("res://assets/gold_outline.png")

# signal dig_action(player, diggable_area)
signal dig_action(player: Player)
signal dig_interrupted(player: Player)

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(name.to_int())
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	$Sprites/ShovelHit.connect("area_entered", _on_shovel_hit_area_entered)
#	print_tree_pretty() #BEST FUNCTION DONT DELETE

	if multiplayer.get_unique_id() == name.to_int():
		get_node("Camera2D").make_current()

	screen_size = get_viewport_rect().size

	gold_icons = [$Control/Gold1, $Control/Gold2, $Control/Gold3]
	$StunTimer.wait_time = stun_duration
	$StunTimer.timeout.connect(Callable(self, "_on_stun_end"))

	animation = $AnimationPlayer
	on_hand_idle_sprite = $Sprites/OnHandIdleSprite
	on_hand_walking_sprite = $Sprites/OnHandWalkSprite
	on_hand_attack_sprite = $Sprites/OnHandAttackSprite
	# Play the idle animation when the scene starts
	animation.play("IdleRight")

func change_hand_item(texture: Texture):
	on_hand_idle_sprite.texture = texture
	on_hand_walking_sprite.texture = texture
	on_hand_attack_sprite.texture = texture

const base_speed = 400
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _input(InputEvent):
	# stop all inputs if stunned
	if is_stunned:
		return

	# listen to SPACEBAR (for weapon)
	if Input.is_action_just_pressed("ui_accept"):
		use_weapon()

	if Input.is_action_just_pressed("equip_shovel"):
		change_hand_item(shovel_texture)

	if Input.is_action_just_pressed("equip_lasso"):
		change_hand_item(lasso_texture)

# handles Player being in a Diggable area
# var is_inside_diggable_area: bool = false
# var current_diggable_area: Area2D = null

# func _on_body_entered(area):
# 	if area.is_in_group("diggable"):
# 		print("entered area")
# 		current_diggable_area = area
# 		# is_inside_diggable_area = true

# func _on_body_exited(area):
# 	if area.is_in_group("diggable"):
# 		current_diggable_area = null
# 		# is_inside_diggable_area = false

func _process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	update_cooldown(delta)

	# stop all inputs if stunned
	if is_stunned:
		# _update_stunned_timer(delta)
		animation.pause()
		# TODO: add dazed status
		return
	else:
		animation.play()
		# TODO: remove dazed status
		pass

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
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	move_and_collide(velocity)

	# dig
	# if current_diggable_area and Input.is_action_just_pressed("dig"):
	if Input.is_action_just_pressed("dig"):
		# print("Emitting")
		dig_action.emit(self)

	if velocity.length() > 0:
		if (Input.is_action_pressed("attack")):
			animation.play("WalkAttackRight")
		else:
			animation.play("WalkRight")
		velocity = velocity.normalized() * speed
		#$AnimatedSprite2D.animation = "walking"
	else:
		if (Input.is_action_pressed("attack")):
			animation.play("IdleAttackRight")
		else:
			animation.play("IdleRight")
		#$AnimatedSprite2D.play()

	position = position.clamp(Vector2.ZERO, screen_size)


var weapon_cooldown_duration = 3.0
var cooldown_timer = 0.0

func use_weapon():
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return

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

# On being hit?
func _on_hit_by_shovel():
	is_stunned = true
	# resets the StunTimer

	$StunTimer.stop()
	$StunTimer.start()
	if is_digging:
		dig_interrupted.emit(self)
		is_digging = false

func _on_stun_end():
	is_stunned = false
	print("Stun completed")
	$StunTimer.stop()
	$StunTimer.wait_time = stun_duration
	print($StunTimer.time_left) # it's 0 right now...
	pass

func _handle_digging():
	# TODO,
	# pause movement, OR,
	# interrupts digging if player moves
	print("Player receives digging signal")
	# TODO:
	# play digging animation
	is_digging = true

func _handle_digging_completed():
	print("Player receives digging completed signal")
	is_digging = false
	# TODO:
	# stop digging animation

func _interrupt_digging():
	dig_interrupted.emit(self)
	is_digging = false
	# TODO:
	# stop digging animation

# Gold collection
func handle_collect_gold():
	print("Collecting gold!!")
	# TODO: handle max 3 gold collected?
	if collected_gold_count < 3:
		collected_gold_count += 1
		_update_gold_ui()
		_update_player_speed_modifier()

func _update_gold_ui():
	for i in range(3):
		if (i < collected_gold_count):
			gold_icons[i].texture = solid_gold_texture
		else:
			gold_icons[i].texture = outline_gold_texture

func handle_deliver_gold():
	GameManager.Teams["1"]["total_gold"] += collected_gold_count
	# print(GameManager.Teams["1"]["total_gold"])
	collected_gold_count = 0
	_update_gold_ui()
	_update_player_speed_modifier()

func _update_player_speed_modifier():
	speed = base_speed * gold_speed_modifier[collected_gold_count]

func _on_shovel_hit_area_entered(area):
	change_hand_item(lasso_texture)
	print("SHOVEL HIT")
	print(area)
