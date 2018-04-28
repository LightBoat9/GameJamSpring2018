extends "res://Field/card_container.gd"

onready var area = get_node("Area2D")
onready var mouse_over = false
var _mouse_relative = Vector2()

var draggable = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not event.pressed and GlobalVars.card_holding == self:
			_drop()
		elif event.pressed and draggable and mouse_over and not GlobalVars.card_holding:
			reset_z_index()
			_mouse_relative = self.global_position - get_global_mouse_position()
			GlobalVars.card_holding = self
			for x in get_tree().get_nodes_in_group("draggables"):
				z_index = max(z_index, x.z_index)
			z_index += 1
			
	
func _ready():
	add_to_group("drag_slots")
	add_to_group("draggables")
	card_offset = Vector2(0, 20)
	area.connect("mouse_entered", self, "_mouse_entered")
	area.connect("mouse_exited", self, "_mouse_exited")
	
func _process(delta):
	if draggable and GlobalVars.card_holding == self:
		self.global_position = get_global_mouse_position() + _mouse_relative
	
func _mouse_entered():
	mouse_over = true
	
func _mouse_exited():
	mouse_over = false
	
func add_card(card):
	# Reparent the card
	if GlobalVars.card_holding == card:
		GlobalVars.card_holding = null
	if card.get_parent():
		if card.get_parent() is preload("res://Field/card_container.gd"):
			card.get_parent().remove_card(card)
		card.get_parent().remove_child(card)
	add_child(card)
	# Set the position
	card.z_index = len(cards)
	card.position = Vector2(0, len(cards) * card_offset.y)
	cards.append(card)
	card.reset_position = card.position
	card.draggable = false
	card.container = self
	card.connect("mouse_entered", self, "hover_top_card")
	card.connect("mouse_exited", self, "hover_top_card")
	reset_z_index()
	
func add_cards_from_array(arr):
	for card in arr:
		add_card(card)
	
func remove_card(card):
	if cards.has(card):
		card.container = null
		if card.get_parent():
			card.get_parent().remove_child(card)
		card.world_parent.add_child(card)
		cards.remove(cards.find(card))
		return card
		
func remove_all_cards():
	var dup = cards.duplicate()
	cards.clear()
	return dup
	
func _drop():
	for inst in get_tree().get_nodes_in_group("drag_slots"):
		if inst != self and inst.mouse_over:
			inst.add_cards_from_array(remove_all_cards())
	self.position = Vector2()
	GlobalVars.card_holding = null
	
func reset_z_index():
	for x in range(len(cards)):
		cards[x].z_index = x
		
func hover_top_card():
	if GlobalVars.card_holding == self:
		return
	var top_card
	for x in range(len(cards)):
		if cards[x].mouse_over:
			top_card = cards[x]
	reset_z_index()
	if top_card:
		for x in get_tree().get_nodes_in_group("draggables"):
			top_card.z_index = max(top_card.z_index, x.z_index)
		top_card.z_index -= 1