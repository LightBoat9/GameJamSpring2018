extends "res://Card/Card.gd"

#Note: this array will contain ENUM VALUES.
#the arrays passed in as parameters contain INGREDIENT CARDS.
#As such, it is necessary to check Ingredient.ingredientIndex
#instead of comparing directly.
var myIngredients = []

func _ready():
	set_current_state("face_up")
	pass

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