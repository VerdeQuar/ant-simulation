extends Node

var rng = RandomNumberGenerator.new()

func randf():
	return rng.randf()

func randf_range(from: float, to: float):
	return rng.randf_range(from, to)

func randfn(mean: float = 0.0, deviation: float = 1.0):
	return rng.randf(mean, deviation)

func randi():
	return rng.randi()

func randi_range(from: float, to: float):
	return rng.randi_range(from, to)
	
func randomize():
	rng.randomize()

func random_point_on_ring(outer_radius: float, inner_radius := 0.0):
	return Vector2.RIGHT.rotated(rng.randf() * TAU) * sqrt(rand_range(pow(1 - (outer_radius - inner_radius) / outer_radius, 2), 1)) * outer_radius

func rotate_within_angle(magnitude: float):
	return Vector2.RIGHT.rotated(rng.randf() * TAU) * magnitude

func choices(choices, weights = [], k = 1, cumulative = false):
	var results = []
	if len(weights) == 0:
		for _i in range(k):
			var choice = choices[rng.randi_range(0, len(choices) - 1)]
			print(choice)
			results.append(choice)
	else:
		var cumulative_weights = []
		var cumulative_sum = 0
		if cumulative:
			cumulative_weights = weights
			cumulative_sum = weights[-1]
		else:
			for weight in weights:
				cumulative_sum += weight
				cumulative_weights.push_back(cumulative_sum)
		
		for _i in range(k):
			var rand = rng.randf() * cumulative_sum
			var idx = 0
			for weight in cumulative_weights:
				if weight > rand:
					break
				idx += 1
		
		
			results.append(choices[idx])
	
	if k == 1:
		return results[0]
	return results
	
