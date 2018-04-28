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
	card.reset_position = card.position
	card.draggable = true
	
func remove_card(card):
	if cards.has(card):
		cards.remove(cards.find(card))
		return card