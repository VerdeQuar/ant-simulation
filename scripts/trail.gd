extends Line2D

export(NodePath) var targetPath
var target
onready var offset = position
func _ready():
	target = get_node(targetPath)

func _process(_delta):
	
	global_position = Vector2.ZERO
	global_rotation = 0

	add_point(get_parent().global_position)
	

	# if get_point_count() > 100:
	# 	remove_point(0)

