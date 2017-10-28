extends Sprite

var steering_control = preload( "res://steering.gd" ).new()
var target_obj = null
var vel = Vector2()
var force = Vector2();
var other_bodies = []

export( String, "steering", "fleeing", "wander" ) var mode = "steering"

func _ready():
	steering_control 
	steering_control.max_vel = 300
	steering_control.max_force = 1000
	other_bodies = get_parent().get_children()
	other_bodies.remove( other_bodies.find( self ) )
	print( "Found ", other_bodies.size() )
	set_fixed_process( true )

func _fixed_process( delta ):
	#if target_obj == null: return
	
	var chase_force = Vector2()
	var cur_pos = get_global_pos()
	
	if target_obj != null:
		if mode == "steering":
			chase_force = steering_control.steering( cur_pos, target_obj.get_global_pos(), vel, delta )
		elif mode == "fleeing":
			chase_force = steering_control.fleeing( get_global_pos(), target_obj.get_global_pos(), vel, 150, delta )
		elif mode == "wander":
			chase_force = steering_control.wander( vel, 100, 50 )

	
	var bound_force = steering_control.rect_bound( cur_pos, vel, Rect2( Vector2( 0, 0 ), Vector2( 1024, 930 ) ).size, 50, 10, delta )
	
	var other_pos = []
	var other_vel = []
	for o in other_bodies:
		other_pos.append( o.get_global_pos() )
		other_vel.append( o.vel )
	var flockforce = Vector2()
	flockforce = steering_control.flocking( cur_pos, vel, other_pos, other_vel, \
			30, 200, \
			200, 1, \
			200, 1 )
	#print( chase_force, " ", flockforce )
	
	var force = chase_force + bound_force + flockforce
	force = steering_control.truncate( force, steering_control.max_force )
	vel += force * delta
	vel = steering_control.truncate( vel, steering_control.max_vel )
	var motion = Vector2()
	motion = vel * delta
	set_pos( cur_pos + motion )
	
	# rotate sprite accordingly
	if vel.x >= 0:
		set_scale( Vector2( 1, 1 ) )
		set_rot( vel.angle() - PI / 2 )
	else:
		set_scale( Vector2( -1, 1 ) )
		set_rot( vel.angle() + PI / 2 )


func set_target( obj ):
	target_obj = obj