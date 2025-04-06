extends Node

var cards : Dictionary = {}

func _ready() -> void:
	var dir = DirAccess.open("res://scenes/cards/")
	if dir:
		var files = dir.get_files()
		for file_name in files:
			if file_name.ends_with(".tres"):
				var id = file_name.get_basename()
				var path = "res://scenes/cards/" + file_name
				var card = load(path)
				if card:
					cards[id] = card
	else:
		push_error("Nie udało się otworzyć folderu z kartami!") #Do poprawy - na jezyk angielski
	

func get_card(id:String) -> CardData:
	return cards.get(id, null)

func get_all_card_ids() -> Array[String]:
	return cards.keys() #Prawdopodobnie blad - sprawdzic
