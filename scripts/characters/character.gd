extends Node2D
class_name Character

signal health_changed(new_hp)
signal max_health_changed(new_max_hp)
signal block_changed(new_block)
signal name_changed(new_name)
signal mana_changed(new_mana)
signal max_mana_changed(new_max_mana)

@export var character_name: String = "Character" :
	set(value):
		character_name = value
		emit_signal("name_changed", value)

@export var max_health: int = 30 :
	set(value):
		max_health = value
		emit_signal("max_health_changed", value)

@export var health: int = 30 :
	set(value):
		health = clamp(value, 0, max_health)
		emit_signal("health_changed", value)
		
@export var max_mana: int = 10 :
	set(value):
		max_mana = value
		emit_signal("max_mana_changed", value)
		
@export var mana: int = 0 :
	set(value):
		mana = max(value, 0)
		emit_signal("mana_changed", value)

@export var block: int = 0 :
	set(value):
		block = max(value, 0)
		emit_signal("block_changed", value)

var deck: Deck

func _ready() -> void:
	deck = Deck.new()

func take_damage(amount: int):
	var final_damage = max(amount - block, 0)
	block = max(block - amount, 0)
	health -= final_damage
	if health < 0:
		health = 0
		print(character_name, " otrzymał ", final_damage, " obrażeń (pozostałe HP: ", health, ")")

func add_block(amount: int):
	block += amount
	print(character_name, " zyskał ", amount, " bloków.")

func add_mana(amount: int):
	mana += amount
	if mana > max_mana:
		mana = max_mana
	mana_changed.emit(mana)

func heal(amount: int):
	health += amount
	if health > max_health:
		health = max_health
	health_changed.emit(health)
