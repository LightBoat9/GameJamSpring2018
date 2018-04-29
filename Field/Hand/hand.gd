extends "res://Field/card_container.gd"

const MAX_CARDS = 5

func _ready():
	card_offset = Vector2(10, 0)
	
func add_card(card):
	# Reparent the card
	if card.get_parent():
		card.get_parent().remove_child(card)
	add_child(card)
	# Set the position
	card.position = (len(cards) * card.texture.get_size() * card.scale) * Vector2(1,0)
	cards.append(card)
	card.container = self
	card.reset_position = card.position
	
func add_cards_from_array(arr):
	for card in arr:
		add_card(card)
		
func remove_card(card):
	if cards.has(card):
		card.container = null
		cards.remove(cards.find(card))
		return card
		
func remove_all_cards():
	var dup = cards.duplicate()
	while not cards.empty():
		remove_card(cards[len(cards)-1])
	return dup