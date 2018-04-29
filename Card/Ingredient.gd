extends "res://Card/Card.gd"

var pointVal = 0
onready var ingredientImage = get_node("VertSplitter/TextureRect")
onready var ingredientIndex setget _loadIngredientTexture
onready var faceUpVisuals = get_node("VertSplitter")
onready var nameLabel = get_node("VertSplitter/HorzSplitter/nameLabel")
onready var pointLabel = get_node("VertSplitter/HorzSplitter/pointLabel")

func face_up_enter():
	faceUpVisuals.show()
	.face_up_enter()

func face_down_enter():
	faceUpVisuals.hide()
	.face_down_enter()

func _loadIngredientTexture(i):
	ingredientIndex = i
	var texPath = "res://Card/textures/ingredients/bread.png"
	var name = "Error"
	match ingredientIndex:
		ingredient.bread:
			texPath = "res://Card/textures/ingredients/bread.png"
			pointVal = 10
			name = "Bread"
		ingredient.lettuce:
			texPath = "res://Card/textures/ingredients/lettuce.png"
			pointVal = 15
			name = "Lettuce"
		ingredient.tomato:
			texPath = "res://Card/textures/ingredients/tomate.png"
			pointVal = 20
			name = "Tomato"
		ingredient.cheese:
			texPath = "res://Card/textures/ingredients/cheese.png"
			pointVal = 30
			name = "Cheese"
		ingredient.butter:
			texPath = "res://Card/textures/ingredients/butter.png"
			pointVal = 20
			name = "Butter"
		ingredient.mayo:
			texPath = "res://Card/textures/ingredients/mayonnaise.png"
			pointVal = 30
			name = "Mayonnaise"
		ingredient.bacon:
			texPath = "res://Card/textures/ingredients/bacon.png"
			pointVal = 45
			name = "Bacon"
		ingredient.beef:
			texPath = "res://Card/textures/ingredients/beef.png"
			pointVal = 50
			name = "Beef"
	
	nameLabel.text = name
	pointLabel.text = str(pointVal)
	ingredientImage.texture = load(texPath)
	