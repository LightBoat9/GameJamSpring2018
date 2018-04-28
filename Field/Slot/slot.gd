extends "res://Field/card_container.gd"

onready var area = get_node("Area2D")
onready var mouse_over = false

func _input(event):
	if GlobalVars.card_holding and mouse_over and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		add_card(GlobalVars.card_holding)

func _ready():
	card_offset = Vector2(0, 20)
	area.connect("mouse_entered", self, "_mouse_entered")
	area.connect("mouse_exited", self, "_mouse_exited")
	
func _mouse_entered():
	mouse_over = true
	
func _mouse_exited():
	mouse_over = false
	
func add_card(card):
	# Reparent the card
	GlobalVars.card_holding = null
	if card.get_parent():
		if card.get_parent() is preload("res://Field/card_container.gd"):
			card.get_parent().remove_card(card)
		card.get_parent().remove_child(card)
	add_child(card)
	# Set the position
	card.position = Vector2(0, len(cards) * card_offset.y)
	cards.append(card)
	card.reset_position = card.position
	card.draggable = false
	
func remove_card(card):
	if cards.has(card):
		cards.remove(cards.find(card))
		return card