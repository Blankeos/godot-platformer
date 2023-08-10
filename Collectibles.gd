extends Node2D

var Cherry = preload("res://Collectibles/Cherry.tscn")



func _on_timer_timeout():
	var cherry_temp = Cherry.instantiate()
	
	var rng = RandomNumberGenerator.new()
	var randX = rng.randi_range(50, 1050)
	var randY = rng.randi_range(200, 280)
	cherry_temp.position = Vector2(randX, randY)
	add_child(cherry_temp)
