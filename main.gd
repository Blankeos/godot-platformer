extends Node2D

func _ready():
#	Utils.saveGame()
	Utils.loadGame()

func _on_button_play_pressed():
	Game.playerHP = 10
	get_tree().change_scene_to_file("res://world.tscn")

func _on_button_quit_pressed():
	get_tree().quit()
#	pass # Replace with function body.
