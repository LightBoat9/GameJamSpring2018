extends "res://Field/card_container.gd"
	
var deck_size = 40
	
var Ingredient = preload("res://Card/Ingredient.tscn")

onready var area = get_node("Area2D")
onready var shape = get_node("Area2D/CollisionShape2D").shape
onready var default_extents = shape.extents

var mouse_over = false
	
func _enter_tree():
	card_offset = Vector2(0,-1.5)
	
func _ready():
	add_to_group("decks")
	area.connect("mouse_entered", self, "mouse_entered")
	area.connect("mouse_exited", self, "mouse_exited")
	
func mouse_entered():
	mouse_over = true
	
func mouse_exited():
	mouse_over = false
	
func new_cards():
	randomize()
	remove_all_cards()
	for x in range(deck_size):
		var inst = Ingredient.instance()
		add_card(inst)
		inst.ingredientIndex = randi() % 7
	
func add_card(card):
	if not card is preload("res://Card/Ingredient.gd"):
		return
	if card.get_parent():
		card.get_parent().remove_child(card)
	add_child(card)
	card.set_current_state("face_down")
	# Set the position
	card.z_index = len(cards)
	card.position = Vector2(0, len(cards) * card_offset.y - card.texture.get_size().y/2)
	cards.append(card)
	shape.extents = Vector2(default_extents.x, default_extents.y + len(cards) * -card_offset.y)
	card.reset_position = card.position
	card.container = self
		
func add_cards_from_array(arr):
	for card in arr:
		add_card(card)
	
func remove_card(card):
	if cards.has(card):
		card.container = null
		cards.remove(cards.find(card))
		shape.extents = Vector2(default_extents.x, default_extents.y + len(cards) * -card_offset.y)
		return card
		
func remove_top_card():
	if len(cards):
		return remove_card(cards[len(cards)-1])
		
func remove_all_cards():
	var dup = cards.duplicate()
	while not cards.empty():
		remove_card(cards[len(cards)-1])
	return dup
	
func add_card_to_bottom(card):
	if not card is preload("res://Card/Ingredient.gd"):
		return
	if card.get_parent():
		card.get_parent().remove_child(card)
	add_child(card)
	card.set_current_state("face_down")
	# Set the position
	cards.push_front(card)
	card.container = self
	align_cards()
	
func align_cards():
	for x in range(len(cards)):
		cards[x].z_index = x
		cards[x].position = Vector2(0, x * card_offset.y - cards[x].texture.get_size().y/2)
		cards[x].reset_position = cards[x].position
	