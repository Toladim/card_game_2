extends Area2D
class_name BattleHex

signal battle_hex_clicked(position)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("battle_hex_clicked",global_position)
