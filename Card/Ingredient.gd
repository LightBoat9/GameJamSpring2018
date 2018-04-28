extends "res://Card/Card.gd"

var pointVal = 0
var ingredientIndex = 0
onready var ingredientImage = get_node("picture")

func _ready():
	set_current_state("face_up")
	_loadIngredientTexture(ingredient.lettuce)

func _loadIngredientTexture(i):
	ingredientIndex = i
	var texPath
	match ingredientIndex:
		ingredient.bread:
			texPath = "res://Card/textures/ingredients/bread.png"
		ingredient.lettuce:
			texPath = "res://Card/textures/ingredients/lettuce.png"
		ingredient.tomato:
			texPath = "res://Card/textures/ingredients/tomate.png"
	
	ingredientImage.texture = load(texPath)