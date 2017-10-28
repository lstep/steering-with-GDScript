extends Sprite

var steering_control = preload( "res://steering.gd" ).new()
var target_obj = null
var vel = Vector2()
var force = Vector2();

export( String, "steering", "steering and arriving", "fleeing", "wander", "pursuit" ) var mode = "steering"

func _ready():
	steering_control 
	steering_control.max_vel = 300
	steering_control.max_force = 1000
	set_fixed_process( true )

func _fixed_process( delta ):
	#if target_obj == null: return
	
	var chase_force = Vector2()
	var cur_pos = get_global_pos()
	
	if target_obj != null:
		if mode == "steering":
			chase_force = steering_control.steering( cur_pos, target_obj.get_global_pos(), vel, delta )
		elif mode == "steering and arriving":
			chase_force = steering_control.steering_and_arriving( cur_pos, target_obj.get_global_pos(), vel, 50, delta )
		elif mode == "fleeing":
			chase_force = steering_control.fleeing( get_global_pos(), target_obj.get_global_pos(), vel, 150, delta )
		elif mode == "wander":
			chase_force = steering_control.wander( vel, 100, 50 )
		elif mode == "pursuit":
			chase_force = steering_control.pursuit( cur_pos, target_obj.get_global_pos(), vel, target_obj.vel, delta )

	
	var bound_force = steering_control.rect_bound( cur_pos, vel, Rect2( Vector2( 0, 0 ), Vector2( 1024, 930 ) ).size, 50, 10, delta )
	
	
	
	var force = chase_force + bound_force
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