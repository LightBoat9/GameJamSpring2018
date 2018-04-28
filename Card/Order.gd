extends "res://Card/Card.gd"

#Note: this array will contain ENUM VALUES.
#the arrays passed in as parameters contain INGREDIENT CARDS.
#As such, it is necessary to check Ingredient.ingredientIndex
#instead of comparing directly.
var myIngredients = []
onready var myGrid = get_node("Container/theGrid")

func _ready():
	set_current_state("face_up")
	
	draggable = true
	var newIngredients = [ingredient.bread, ingredient.lettuce, ingredient.tomato, ingredient.bread]
	myIngredients += newIngredients
	_loadIntoGrid()

func _loadIntoGrid():
	for part in myIngredients:
		var texPath
		match part:
			ingredient.bread:
				texPath = "res://Card/textures/ingredients/bread.png"
			ingredient.lettuce:
				texPath = "res://Card/textures/ingredients/lettuce.png"
			ingredient.tomato:
				texPath = "res://Card/textures/ingredients/tomate.png"
		var rectangle = TextureRect.new()
		var scaleFactor = 0.33
		rectangle.texture = load(texPath)
		rectangle.expand = true
		rectangle.stretch_mode = rectangle.STRETCH_SCALE
		rectangle.rect_min_size = Vector2(200.0,200.0)*scaleFactor
		rectangle.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		myGrid.add_child(rectangle)

func _findIngredient(val,ingredients):
	for i in range(ingredients.count):
		if ingredients[i].ingredientIndex == val:
			return i
	return -1

func _validateIngredients(ingredients):
	for temp in myIngredients:
		if _findIngredient(temp,ingredients):
			return false
	return true

#Warning: only call this after _validateIngredients has passed
#It'll mess stuff up otherwise
func _scoreIngredients(ingredients):
	var score = 0
	
	for myIngredient in myIngredients:
		var ind = _findIngredient(myIngredient,ingredients)
		score += ingredients[ind].pointVal
		ingredients.remove(ind)
	
	for extra in ingredients:
		score -= extra.pointVal
	
	return score