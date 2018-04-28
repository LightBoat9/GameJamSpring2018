extends "res://Card/Card.gd"

var pointVal = 0
var ingredientIndex = 0

func _ready():
	set_current_state("face_up")
	_loadIngredientTexture(ingredient.lettuce)

func _loadIngredientTexture(i):
	ingredientIndex = i
	var texPath
	match ingredientIndex:
		ingredient.bread:
			texPath = "res://Card/textures/placeHolder_bread.png"
		ingredient.lettuce:
			texPath = "res://Card/textures/placeHolder_wettuce.png"
	
	tex_faceUp = load(texPath)