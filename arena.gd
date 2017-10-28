extends Node2D

var mode = "individual"
var cur_scene = ""

func _ready():
	var boids = get_tree().get_nodes_in_group( "boids" )
	for b in boids:
		b.set_target( get_node( "Sprite" ) )

func _on_individual_pressed():
	if cur_scene != "demo_steering.tscn":
		_load_scene( "demo_steering.tscn" )
	get_node( "hud/individual behavior/btn_steering" ).show()
	get_node( "hud/individual behavior/btn_steering_and_arriving" ).show()
	get_node( "hud/individual behavior/btn_fleeing" ).show()
	get_node( "hud/individual behavior/btn_wander" ).show()
	get_node( "hud/individual behavior/btn_pursuit" ).show()
	get_node( "hud/individual behavior/btn_none" ).hide()
	mode = "individual"

func _on_group_pressed():
	if cur_scene != "demo_flocking.tscn":
		_load_scene( "demo_flocking.tscn" )
	get_node( "hud/individual behavior/btn_steering" ).show()
	get_node( "hud/individual behavior/btn_steering_and_arriving" ).hide()
	get_node( "hud/individual behavior/btn_fleeing" ).show()
	get_node( "hud/individual behavior/btn_wander" ).show()
	get_node( "hud/individual behavior/btn_pursuit" ).hide()
	get_node( "hud/individual behavior/btn_none" ).show()
	mode = "group"









func _load_scene( scene_name ):
	# clear current scene
	var children = get_node( "scene" ).get_children()
	for child in children:
		child.queue_free()
	
	# load next scene
	var nxt_scene = load( scene_name )
	
	# instance next scene
	get_node( "scene" ).add_child( nxt_scene.instance() )






func _on_btn_steering_pressed():
	var fishes = get_tree().get_nodes_in_group( "fish" )
	for f in fishes:
		f.mode = "steering"


func _on_btn_steering_and_arriving_pressed():
	var fishes = get_tree().get_nodes_in_group( "fish" )
	for f in fishes:
		f.mode = "steering and arriving"


func _on_btn_fleeing_pressed():
	var fishes = get_tree().get_nodes_in_group( "fish" )
	for f in fishes:
		f.mode = "fleeing"


func _on_btn_wander_pressed():
	var fishes = get_tree().get_nodes_in_group( "fish" )
	for f in fishes:
		f.mode = "wander"



func _on_btn_pursuit_pressed():
	var fishes = get_tree().get_nodes_in_group( "fish" )
	for f in fishes:
		f.mode = "pursuit"


func _on_btn_none_pressed():
	var fishes = get_tree().get_nodes_in_group( "fish" )
	for f in fishes:
		f.mode = ""
