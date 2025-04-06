extends Node

const SAVE_PATH := "user://save_file.json"

func save_deck(card_ids: Array[String]) -> void:
	var data = {
		"player_deck" : card_ids
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	print("poprawnie zapisano gre")

func load_deck() -> Array[String]:
	if not FileAccess.file_exists(SAVE_PATH):
		print("plik zapisu nie istnieje")
		return []
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(content)
	if result == null or typeof(result) != TYPE_DICTIONARY:
		print("zly typ wczytywanego pliku zapisu")
		return []
		
	var loaded_raw = result.get("player_deck", [])
	var loaded_clean: Array[String] = []
	for item in loaded_raw:
		
		if typeof(item) == TYPE_STRING:
			loaded_clean.append(item)
		else:
			loaded_clean.append(str(item))
			
	print("poprawnie wczytano talie gracza", loaded_clean)
	return loaded_clean
