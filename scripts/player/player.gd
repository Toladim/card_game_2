extends Character
class_name Player

func _ready() -> void:
	super._ready()
	var data = GameSession.player_data
	if not data:
		push_error("Nie wczytano danych gracza")
		return
	
	character_name = data.player_name
	health = data.current_health
	max_health = data.max_health
