extends Node

var Order = preload("res://Card/Order.tscn")
var offset = Vector2(0, 250.0/2.0)
var orders = []
			
func new_orders():
	for y in range(3):
		var inst = Order.instance()
		add_child(inst)
		inst.random_order()
		inst.position = Vector2(0,y) * offset
		inst.reset_position = inst.position
		orders.append(inst)
			
func add_orders_from_array(arr):
	for order in arr:
		if order.get_parent():
			Order.get_parent().remove_child(order)
		add_child(order)
		order.position = Vector2(0,len(orders)) * offset
		orders.append(order)
		order.reset_position = order.position
			
func remove_all_orders():
	var dup = orders.duplicate()
	while len(orders) > 0:
		var order = orders.pop_back()
		if order.get_parent():
			order.get_parent().remove_child(order)
		order.container = null
	return dup