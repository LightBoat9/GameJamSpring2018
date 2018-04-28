extends "res://BaseScripts/state_machine.gd"

var current_player = 1
var waiting_player = 2
var player_1_hand = []
var player_2_hand = []
var player_1_deck = []
var player_2_deck = []

var next_state

onready var hand = get_parent().get_node("Hand")
onready var deck = get_parent().get_node("Deck")
onready var button = get_node("Button")
onready var text_area = get_node("Label")

func _ready():
	set_current_state("new_game")
	button.connect("pressed", self, "button_pressed")

func button_pressed():
	set_current_state(next_state)

func new_game_enter():
	text_area.text = "Player " + str(waiting_player) + " Look Away!"
	new_cards()
	player_2_deck = deck.remove_all_cards()
	player_2_hand = hand.remove_all_cards()
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
	text_area.text = "Player " + str(waiting_player) + " Look Away!"
	next_state = "play_cards"
	
func player_cards_exit():
	change_players()

func set_hand_state(state):
	for x in hand.cards:
		x.set_current_state(state)
		
func change_players():
	if current_player != waiting_player:
		player_1_hand = hand.remove_all_cards()
		player_1_deck = deck.remove_all_cards()
		hand.add_cards_from_array(player_2_hand)
		deck.add_cards_from_array(player_2_deck)
	else:
		player_2_hand = hand.remove_all_cards()
		player_2_deck = deck.remove_all_cards()
		hand.add_cards_from_array(player_1_hand)
		deck.add_cards_from_array(player_1_deck)
	var temp = current_player
	current_player = waiting_player
	waiting_player = temp
		
func new_cards():
	deck.new_cards()
	for i in range(hand.MAX_CARDS):
		var card = deck.remove_top_card()
		hand.add_card(card)