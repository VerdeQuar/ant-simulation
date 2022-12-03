extends KinematicBody2D

export(int) var speed = 50
export(float) var wander_strength = 1.0
export(float) var steering_strength = 1.0
export(float) var steering_degrees = 20.0
export(float) var anthill_direction_sense = 1.0

var anthill

export(NodePath) var left_sensor_path
onready var left_sensor = get_node(left_sensor_path)

export(NodePath) var middle_sensor_path
onready var middle_sensor = get_node(middle_sensor_path)

export(NodePath) var right_sensor_path
onready var right_sensor = get_node(right_sensor_path)

export(NodePath) var mouth_path
onready var mouth = get_node(mouth_path)

export(PackedScene) var pheromone

var left_weight = 1
var middle_weight = 1
var right_weight = 1

var desired_direction = Rng.random_point_on_ring(10)
var velocity = Vector2.ZERO
onready var target = null

enum States {WANDERING, RETURNING, DEPLEASHED}
var state = States.WANDERING
var holding = null

# var desired_direction = Vector2.RIGHT
# var desired_direction = (rotate_within_angle(wander_strength)).normalized()

func _physics_process(delta):
	# target = get_global_mouse_position()
	# while direction.dot(desired_direction) < 0:
	# 	desired_direction = random_point_on_ring(1).normalized()
	# left_sensor_weight = 1 #count_nodes(left_sensor, 10)
	# middle_sensor_weight = (left_sensor_weight + right_sensor_weight) #count_nodes(left_sensor, 10)
	# right_sensor_weight = 1 #count_nodes(right_sensor, 10)
	
	if state == States.WANDERING:
		left_weight = 1 + left_sensor.get_pheromones_strength("pheromone_food") + left_sensor.get_pheromones_strength("food") - left_sensor.get_pheromones_strength("pheromone_source_depleashed")
		middle_weight = 1 + middle_sensor.get_pheromones_strength("pheromone_food") + middle_sensor.get_pheromones_strength("food") - middle_sensor.get_pheromones_strength("pheromone_source_depleashed")
		right_weight = 1 + right_sensor.get_pheromones_strength("pheromone_food") + right_sensor.get_pheromones_strength("food") - right_sensor.get_pheromones_strength("pheromone_source_depleashed")
	elif state == States.RETURNING:
		left_weight = 1 + left_sensor.get_pheromones_strength("pheromone_anthill")
		middle_weight = 1 + middle_sensor.get_pheromones_strength("pheromone_anthill")
		right_weight = 1 + right_sensor.get_pheromones_strength("pheromone_anthill")

	# print("left: ", left_weight)
	# print("middle: ", middle_weight)
	# print("right: ", right_weight)

	desired_direction = (desired_direction.rotated(
							Rng.choices(
								[deg2rad(-steering_degrees), 0, deg2rad(steering_degrees)], 
								[
									left_weight, 
									middle_weight, 
									right_weight,
								]
							) * wander_strength
						)).normalized()
	
	if state == States.RETURNING:
		desired_direction += position.direction_to(anthill.global_position).normalized() * anthill_direction_sense * delta
	# desired_direction = position.direction_to(target).normalized()	

	var desired_velocity = desired_direction * speed
	var acceleration = ((desired_velocity - velocity) * steering_strength).limit_length(steering_strength)
	velocity = (velocity + acceleration).limit_length(speed)
	
	look_at(global_position + velocity)
	
	# velocity = (velocity + (direction * speed)).limit_length(max_speed)

	var collision = move_and_collide(velocity * delta)
	if collision:
		if desired_direction.dot(collision.normal) < 0:
			velocity *= 0.25
			desired_direction = desired_direction.bounce(collision.normal)
	if holding and weakref(holding).get_ref():	
		holding.global_position = mouth.global_position

func _on_Mouth_body_entered(body:Node):
	if state == States.WANDERING:
		if holding:
			return
			
		if not body.is_in_group("food"):
			return
		
		state = States.RETURNING
		desired_direction *= -1
		velocity *= 0.25

		holding = body

func _on_Mouth_area_entered(area:Area2D):
	if not holding:
		 return
	if not state == States.RETURNING:
		return
	if not area.is_in_group("anthill"):
		return

	if weakref(holding).get_ref():
		holding.queue_free()

	holding = null
	area.emit_signal("increment_score")
	desired_direction *= -1
	state = States.WANDERING

func _on_Timer_timeout():
	var instance = pheromone.instance()
	instance.global_position = global_position
	if state == States.WANDERING:
		instance.type = instance.Types.ANTHILL
	elif state == States.RETURNING:
		instance.type = instance.Types.FOOD
	get_tree().get_root().add_child(instance)


