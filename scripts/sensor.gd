extends Area2D

var pheromones = []

func get_sensor_value(positive_group, negative_group):
	var value = 1
	for pheromone in pheromones:
		if positive_group and pheromone.is_in_group(positive_group):
			value += pheromone.strength
		if negative_group and pheromone.is_in_group(negative_group):
			value -= pheromone.strength
	return value

func get_pheromones_strength(group):
	var strength = 0
	for pheromone in pheromones:
		if group and pheromone.is_in_group(group):
			strength += pheromone.strength
	return strength



func _on_Sensor_body_entered(body:Node):
	if body.is_in_group("pheromones") or body.is_in_group("food"):
		pheromones.append(body)

func _on_Sensor_body_exited(body:Node):
	if body.is_in_group("pheromones") or body.is_in_group("food"):
		pheromones.remove(pheromones.find(body))
