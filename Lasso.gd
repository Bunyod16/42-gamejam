extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide() #place with function body.
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_2d_area_entered(area):
	if get_parent() == null:
		return
	if get_parent().get_parent() == null:
		return
	if area.owner == null:
		return
	if area.owner.name.to_int() not in GameManager.Players:
		return
		
	print("name: ", get_parent().get_parent().name)
	print("area: ", area.owner.name)
	
	var shooter_id = get_parent().get_parent().name.to_int()
	var receiver_id = area.owner.name.to_int()
	
	var shooter_obj = GameManager.Players[shooter_id]
	var receiver_obj = GameManager.Players[receiver_id]
	
	
	var can_steal = 3 - shooter_obj.collected_gold
	var gold_stolen = min(receiver_obj.collected_gold, can_steal)
	
	print("can_steal: ", can_steal)
	print("gold_stolen: ", gold_stolen)
	
	if gold_stolen < 0:
		return
	if receiver_obj.collected_gold == 3 or can_steal == 0:
		return

	print("before", GameManager.Players)
	
	#Shooter of lasso gets all his gold
	GameManager.update_player_information(shooter_id, shooter_obj.name, shooter_obj.health, shooter_obj.gold, shooter_obj.collected_gold + gold_stolen)
	
	#Receiver of lasso loses all collected_gold
	GameManager.update_player_information(receiver_id, receiver_obj.name, receiver_obj.health, receiver_obj.gold, receiver_obj.collected_gold - gold_stolen)
	print("Lasso HIT!") # Replace with function body.
