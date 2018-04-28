extends "res://Card/Card.gd"

var pointVal = 0
onready var ingredientImage = get_node("Splitter/picture")
onready var ingredientIndex setget _loadIngredientTexture

func _ready():
	set_current_state("face_up")
	
	draggable = true

func face_up_enter():
	ingredientImage.show()

func face_down_enter():
	ingredientImage.hide()

func _loadIngredientTexture(i):
	ingredientIndex = i
	var texPath = "res://Card/textures/ingredients/bread.png"
	match ingredientIndex:
		ingredient.bread:
			texPath = "res://Card/textures/ingredients/bread.png"
			pointVal = 10
		ingredient.lettuce:
			texPath = "res://Card/textures/ingredients/lettuce.png"
			pointVal = 20
		ingredient.tomato:
			texPath = "res://Card/textures/ingredients/tomate.png"
			pointVal = 20
	
	ingredientImage.texture = load(texPath)