extends "res://BaseScripts/state_machine.gd"

var current_player = 1

var next_state

onready var hand = get_parent().get_node("Hand")
onready var temp_hand = get_parent().get_node("TempHand")
onready var deck = get_parent().get_node("Deck")
onready var temp_deck = get_parent().get_node("TempDeck")
onready var button = get_node("Button")
onready var text_area = get_node("Label")

func _ready():
	set_current_state("new_game")
	button.connect("pressed", self, "button_pressed")

func button_pressed():
	set_current_state(next_state)

func new_game_enter():
	text_area.text = "Player " + str(1 if current_player == 2 else 2) + " Look Away!"
	new_cards()
	temp_hand.add_cards_from_array(hand.remove_all_cards())
	temp_deck.add_cards_from_array(deck.remove_all_cards())
	new_cards()
	next_state = "play_cards"

func play_cards_enter():
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
	var temp2 = temp_deck.remove_all_cards()
	temp_hand.add_cards_from_array(hand.remove_all_cards())
	temp_deck.add_cards_from_array(deck.remove_all_cards())
	hand.add_cards_from_array(temp1)
	deck.add_cards_from_array(temp2)
	current_player = 1 if current_player == 2 else 2
		
func new_cards():
	deck.new_cards()
	for i in range(hand.MAX_CARDS):
		var card = deck.remove_top_card()
		hand.add_card(card)