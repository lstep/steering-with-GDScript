extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var boids = get_tree().get_nodes_in_group( "boids" )
	for b in boids:
		b.set_target( get_node( "Sprite" ) )
