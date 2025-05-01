extends Resource
class_name CardData

enum Type {
	WEAPON,		# bronie: miecze, łuki, topory itp.
	ARMOR,		# pancerze, tarcze, blok
	ABILITY,	# umiejętności postaci: cios krytyczny, ognista kula
	ITEM,		# mikstury, zwoje, trucizny
	SPELL,		# magia ofensywna lub defensywna
	SUPPORT,	# buffy, leczenie, pasywki
	QUEST		# przedmioty do zadan
	}
enum Target {
	SELF,
	ALLY,
	SINGLE_ENEMY,
	ALL_ENEMIES,
	ANY
}

@export_category("Card Generals")
@export var card_name : String = ""
@export_multiline var description : String =""
@export var type: Type
@export var target: Target
@export var texture : AtlasTexture
@export var card_effects : Array[CardEffect]
@export var mana_cost : int = 0
