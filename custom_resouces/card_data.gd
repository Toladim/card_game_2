extends Resource
class_name CardData

enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_category("Card Attributes")
@export var card_name : String = ""
@export var attack : int = 0
@export var deffence : int = 0
@export var texture : Texture2D
@export var type: Type
@export var target: Target
