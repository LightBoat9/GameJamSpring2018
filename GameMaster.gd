extends "res://BaseScripts/state_machine.gd"

var current_player = 1

onready var scores_labels = [get_node("P1Score"), get_node("P2Score")]
onready var scores = [0,0]

var next_state

onready var hand = get_parent().get_node("Hand")
onready var temp_hand = get_parent().get_node("TempHand")
onready var orders = get_parent().get_node("OrderGrid")
onready var temp_orders = get_parent().get_node("TempOrder")
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

func return_to_deck_arr(arr):
	while len(arr) > 0:
		return_to_deck(arr.pop_front())

func button_pressed():
	set_current_state(next_state)

func new_game_enter():
	text_area.text = "Player " + str(1 if current_player == 2 else 2) + " Look Away!"
	deck.new_cards()
	deck.shuffle(100)
	draw(5)
	temp_hand.add_cards_from_array(hand.remove_all_cards())
	orders.new_orders()
	temp_orders.add_orders_from_array(orders.remove_all_orders())
	orders.new_orders()
	set_order_state("face_down")
	draw(5)
	next_state = "play_cards"

func play_cards_enter():
	if len(hand.cards) < hand.MAX_CARDS:
		draw(1)
	text_area.text = "Player " + str(current_player) + "'s Play Phase"
	button.text = "End Turn"
	set_hand_state("face_up")
	set_order_state("face_up")
	next_state = "change_player"
	
func change_player_enter():
	change_players()
	set_hand_state("face_down")
	set_order_state("face_down")
	text_area.text = "Player " + str(1 if current_player == 2 else 2) + " Look Away!"
	next_state = "play_cards"
	
func player_cards_exit():
	change_players()

func set_hand_state(state):
	for x in hand.cards:
		x.set_current_state(state)
		
func set_order_state(state):
	for x in orders.orders:
		x.set_current_state(state)
		
func change_players():
	var temp1 = temp_hand.remove_all_cards()
	temp_hand.add_cards_from_array(hand.remove_all_cards())
	hand.add_cards_from_array(temp1)
	
	var temp2 = temp_orders.remove_all_orders()
	temp_orders.add_orders_from_array(orders.remove_all_orders())
	orders.add_orders_from_array(temp2)
	current_player = 1 if current_player == 2 else 2
		
func draw(amount):
	for i in range(amount):
		var card = deck.remove_top_card()
		hand.add_card(card)
		
func add_score(amount):
	scores[current_player-1] += amount
	scores_labels[current_player-1].text = "P" + str(current_player) + " Score: " + str(scores[current_player-1])