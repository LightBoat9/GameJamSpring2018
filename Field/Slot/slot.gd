extends "res://Field/card_container.gd"

onready var area = get_node("Area2D")
onready var mouse_over = false

func _ready():
	card_offset = Vector2(0, 20)
	area.connect("mouse_entered", self, "_mouse_entered")
	area.connect("mouse_exited", self, "_mouse_exited")
	
func _input(event):
	if GlobalVars.card_holding and event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		add_card(GlobalVars.card_holding)
	
func _mouse_entered():
	mouse_over = true
	
func _mouse_exited():
	mouse_over = false
	
func add_card(card):
	# Reparent the card
	if card.get_parent():
		card.get_parent().remove_child(card)
	add_child(card)
	# Set the position
	card.position = position + len(cards) * card_offset
	cards.append(card)