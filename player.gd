extends KinematicBody2D

var input_states = preload( "res://input_states.gd" )
var btn_left = input_states.new( "btn_left" )
var btn_right = input_states.new( "btn_right" )
var btn_up = input_states.new( "btn_up" )
var btn_down = input_states.new( "btn_down" )

const MAX_VEL = 300
const ACCEL = 10
var vel = Vector2()

func _ready():
	set_fixed_process( true )

func _fixed_process( delta ):
	# input
	if btn_up.check() == 2:
		vel.y = lerp( vel.y, -MAX_VEL, ACCEL * delta )
	elif btn_down.check() == 2:
		vel.y = lerp( vel.y, MAX_VEL, ACCEL * delta )
	else:
		vel.y = lerp( vel.y, 0, 0.5 * ACCEL * delta )
		
	if btn_left.check() == 2:
		vel.x = lerp( vel.x, -MAX_VEL, ACCEL * delta )
	elif btn_right.check() == 2:
		vel.x = lerp( vel.x, MAX_VEL, ACCEL * delta )
	else:
		vel.x = lerp( vel.x, 0, 0.5 * ACCEL * delta )
	
	# motion
	vel = move_and_slide( vel )
	
	# rotate sprite
	if vel.x >= 0:
		get_node( "Sprite" ).set_scale( Vector2( 1, 1 ) )
		get_node( "Sprite" ).set_rot( vel.angle() - PI / 2 )
	else:
		get_node("Sprite").set_scale( Vector2( -1, 1 ) )
		get_node( "Sprite" ).set_rot( vel.angle() + PI / 2 )
	
