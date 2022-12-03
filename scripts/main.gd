extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var ant
export(PackedScene) var food

export(NodePath) var anthill_path
onready var anthill = get_node(anthill_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	Rng.randomize()

	for _i in range(50):
		var ant_instance = ant.instance()
		ant_instance.position = Rng.random_point_on_ring(10) + anthill.global_position
		ant_instance.anthill = anthill
		add_child(ant_instance)

	var screen_size = get_viewport().get_visible_rect().size
	for _i in range(10):
		var clump = Vector2(Rng.randi_range(0, screen_size.x), Rng.randi_range(0, screen_size.y))
		for _j in range(100):
			var food_instance = food.instance()
			food_instance.position = Rng.random_point_on_ring(50) + clump
			add_child(food_instance)
