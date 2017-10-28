extends Sprite

var steering_control
var target_obj = null
var vel = Vector2()
var force = Vector2();
var other_bodies = []

func _ready():
	steering_control = preload( "res://steering.gd" ).new()
	steering_control.max_vel = 250
	steering_control.max_force = 1000
	
	other_bodies = get_tree().get_nodes_in_group( "boids" )
	other_bodies.remove( other_bodies.find( self ) )
	print( other_bodies )
	
	set_fixed_process( true )

func _fixed_process( delta ):
	#if target_obj == null: return
	
	var chase_force = Vector2()
	var cur_pos = get_global_pos()
	
	if target_obj != null:
		#chase_force = steering_control.steering( cur_pos, target_obj.get_global_pos(), vel, delta )
		#chase_force = steering_control.steering_and_arriving( cur_pos, target_obj.get_global_pos(), vel, 50, delta )
		chase_force = steering_control.fleeing( get_global_pos(), target_obj.get_global_pos(), vel, 150, delta )
		#chase_force = steering_control.pursuit( cur_pos, target_obj.get_global_pos(), vel, target_obj.vel, delta )
		pass
	#chase_force = steering_control.wander( vel, 100, 50 )
	
	
	var other_pos = []
	var other_vel = []
	for o in other_bodies:
		other_pos.append( o.get_global_pos() )
		other_vel.append( o.vel )
	
	var flockforce = Vector2()
	#var separation_force = steering_control.separation( cur_pos, other_pos, 500, 30 )
	#var alignment_force = steering_control.alignment( cur_pos, other_pos, vel, other_vel, 200 )
	#var cohesion_force = steering_control.cohesion( cur_pos, other_pos, 1, 200 )
	#flockforce = separation_force + alignment_force + cohesion_force
	flockforce = steering_control.flocking( cur_pos, vel, other_pos, other_vel, \
			30, 200, \
			200, 1, \
			200, 1 )
	
	var bound_force = steering_control.rect_bound( cur_pos, vel, get_viewport_rect().size, 50, 10, delta )
	
	
	
	var force = chase_force + flockforce + bound_force
	force = steering_control.truncate( force, steering_control.max_force )
	vel += force * delta
	vel = steering_control.truncate( vel, steering_control.max_vel )
	var motion = Vector2()
	motion = vel * delta
	set_pos( cur_pos + motion )
	
	# rotate sprite accordingly
	set_rot( PI + vel.angle() )


func set_target( obj ):
	target_obj = obj
	
