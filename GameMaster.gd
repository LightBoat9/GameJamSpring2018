extends "res://BaseScripts/state_machine.gd"

var current_player = 1

var next_state

onready var hand = get_parent().get_node("Hand")
onready var temp_hand = get_parent().get_node("TempHand")
onready var deck = get_parent().get_node("Deck")
onready var button = get_node("Button")
onready var text_area = get_node("Label")

func _ready():
	set_current_state("new_game")
	button.connect("pressed", self, "button_pressed")
	
func return_to_deck(card):
	if card.container:
		card.container.remove_card(card)
	deck.add_card_to_bottom(card)

func button_pressed():
	set_current_state(next_state)

func new_game_enter():
	text_area.text = "Player " + str(1 if current_player == 2 else 2) + " Look Away!"
	deck.new_cards()
	draw(5)
	temp_hand.add_cards_from_array(hand.remove_all_cards())
	draw(5)
	next_state = "play_cards"

func play_cards_enter():
	if len(hand.cards) < hand.MAX_CARDS:
		draw(1)
	text_area.text = "Player " + str(current_player) + "'s Play Phase"
	button.text = "End Turn"
	set_hand_state("face_up")
	next_state = "change_player"
	
func change_player_enter():
	change_players()
	set_hand_state("face_down")
	text_area.text = "Player " + str(1 if current_player == 2 else 2) + " Look Away!"
	next_state = "play_cards"
	
func player_cards_exit():
	change_players()

func set_hand_state(state):
	for x in hand.cards:
		x.set_current_state(state)
		
func change_players():
	var temp1 = temp_hand.remove_all_cards()
	temp_hand.add_cards_from_array(hand.remove_all_cards())
	hand.add_cards_from_array(temp1)
	current_player = 1 if current_player == 2 else 2
		
func draw(amount):
	for i in range(amount):
		var card = deck.remove_top_card()
		hand.add_card(card)