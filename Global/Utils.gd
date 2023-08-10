extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"cherries": Game.cherries,
	}
	
	var jsonStr = JSON.stringify(data)
	file.store_line(jsonStr)
	
func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if (current_line):
				Game.cherries = current_line.get("cherries") if current_line.has("cherries") else 0
				Game.playerHP = current_line.get("playerHP") if current_line.has("playerHP") else 0
