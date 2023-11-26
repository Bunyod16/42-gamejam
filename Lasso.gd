extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide() #place with function body.
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_2d_area_entered(area):
	print("name: ", get_parent().name)
	print("area: ", area.name)
#	var player_id = area.to_int()
#	var player_obj = GameManager.Players[player_id]
#
#	print("before", GameManager.Players)
#	GameManager.update_player_information(player_id, player_obj.name, player_obj.health, player_obj.gold + collected_gold_count)
#	print("Lasso HIT!") # Replace with function body.
