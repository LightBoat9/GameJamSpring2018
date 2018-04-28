extends "res://Card/Card.gd"

var pointVal = 0
var ingredientIndex

func _ready():
	_loadIngredientTexture(ingredient.bread)
	
	set_current_state("face_up")

func _loadIngredientTexture(i):
	ingredientIndex = i
	match ingredientIndex:
		ingredient.bread:
			tex_faceUp = load("res://Card/textures/placeHolder_bread.png")