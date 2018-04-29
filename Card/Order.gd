extends "res://Card/Card.gd"

#Note: this array will contain ENUM VALUES.
#the arrays passed in as parameters contain INGREDIENT CARDS.
#As such, it is necessary to check Ingredient.ingredientIndex
#instead of comparing directly.
var myIngredients = []
onready var myGrid = get_node("splitter/theGrid")
onready var nameLabel = get_node("splitter/labelSplitter/nameLabel")
onready var pointLabel = get_node("splitter/labelSplitter/pointLabel")
onready var faceUpVisuals = get_node("splitter")
var perfectBonus = 0

func _ready():
	set_current_state("face_up")
	add_to_group("SandwichReceptacles")
	
	draggable = true
	
	_generateOrder(0)

func face_up_enter():
	faceUpVisuals.show()

func face_down_enter():
	faceUpVisuals.hide()

func _setOrder(inputIngredients):
	myIngredients = inputIngredients.duplicate()

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
	for i in len(ingredients):
		if ingredients[i].ingredientIndex == val:
			return i
	return -1

func _validateIngredients(ingredients):
	var tempInputs = ingredients.duplicate()
	
	for temp in myIngredients:
		var index = _findIngredient(temp,tempInputs)
		if index==-1:
			return false
		else:
			tempInputs.remove(index)
	return true

#Warning: only call this after _validateIngredients has passed
#It'll mess stuff up otherwise
func _scoreIngredients(ingredients):
	var score = 0
	
	for myIngredient in myIngredients:
		var ind = _findIngredient(myIngredient,ingredients)
		score += ingredients[ind].pointVal
		ingredients[ind].queue_free()
		ingredients.remove(ind)
		
	
	score += perfectBonus*int((len(ingredients)==0))
	
	for extra in ingredients:
		score -= extra.pointVal
	
	return score

func _generateOrder(index):
	var newOrder = [ingredient.bread]
	var orderName = "Error"
	
	match index:
		0:
			newOrder += [ingredient.lettuce, ingredient.tomato]
			perfectBonus = 20
			orderName = "Boring Sandwich"
		1:
			newOrder += [ingredient.cheese]
			perfectBonus = 10
			orderName = "Cheese Sandwich"
		2:
			newOrder += [ingredient.cheese, ingredient.butter]
			perfectBonus = 40
			orderName = "Grilled Cheese"
	
	nameLabel.text = orderName
	pointLabel.text = str(perfectBonus)
	myIngredients = newOrder+[ingredient.bread]
	_loadIntoGrid()