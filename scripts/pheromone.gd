extends KinematicBody2D

export(float) var fade_speed = 0.05
var strength = 1.0
enum Types {ANTHILL, FOOD, SOURCE_DEPLEASHED}
var type = Types.ANTHILL

export var anthill_color: Color
export var food_color: Color
export var source_depleashed_color: Color

func _ready():
	if type == Types.FOOD:
		modulate = food_color
		add_to_group("pheromone_food")
	elif type == Types.ANTHILL:
		modulate = anthill_color
		add_to_group("pheromone_anthill")
	elif type == Types.SOURCE_DEPLEASHED:
		modulate = source_depleashed_color
		add_to_group("pheromone_source_depleashed")

func _process(delta):
	strength = clamp(strength - (delta * fade_speed), 0.0, 1.0)
	modulate.a = strength

	if strength == 0.0:
		queue_free()
	