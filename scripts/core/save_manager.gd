extends Node
const SAVE_PATH := "user://save_file.json"

func save_game(data: PlayerData) -> void:
	if not data:
		push_error("Brak danych gracza do zapisu")
		return
	
	var save_dict = {
		"char_name" = data.char_name,
		"current_health" = data.current_health,
		"max_health" = data.max_health,
		"mana" = data.mana,
		"max_mana" = data.max_mana,
		"deck_ids" = data.deck_ids,
		"owned_cards" = data.owned_cards
		}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))
	file.close()
	print("poprawnie zapisano gre")
	
func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Plik zapisu nie istnieje")
		return null
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(content)
	if typeof(result) != TYPE_DICTIONARY:
		push_error("Błędny typ danych zapisu")
		return null
		
	var data = PlayerData.new()
	data.char_name = result.get("char_name", "Unnamed")
	data.current_health = result.get("current_health", 10)
	data.max_health = result.get("max_health", 10)
	data.mana = result.get("mana", 2)
	data.max_mana = result.get("max_mana", 10)
	var raw_ids = result.get("deck_ids", [])
	var deck_ids : Array[String] = []
	
	for id in raw_ids:
		if typeof(id) == TYPE_STRING:
			deck_ids.append(id)
		else:
			deck_ids.append(str(id))
	data.deck_ids = deck_ids
	
	var raw_owned = result.get("owned_cards", {})
	var parsed_owned : Dictionary = {}
	for key in raw_owned.keys():
		var count = int(raw_owned[key])
		if count > 0:
			parsed_owned[str(key)] = count
	data.owned_cards = parsed_owned
	
	print("Gra została wczytana:", data.deck_ids)
	return data
