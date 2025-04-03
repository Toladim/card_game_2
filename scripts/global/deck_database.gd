extends Node

var cards : Dictionary = {}

func _ready() -> void:
	var dir = DirAccess.open("res://scenes/cards/")
	if dir:
		var files = dir.get_files()
		for file_name in files:
			print("a")
