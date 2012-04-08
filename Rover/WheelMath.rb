# %% Wheel designations: 

# % 1: back-left
# % 2: middle-left
# % 3: front-left
# % 4: back-right
# % 5: middle-right
# % 6: front-right

# %% constants
def setup_constants
	@b = 0.381
	@w = 0.7396/2
	@R = 0.232
	@vMax = 1.3
	@cMax = 1.0/@w - 0.001
	@thetaMax = (3.14159/180)*140
end

def input_joystick
	#@right_joystick_percent = -75.0
	#@left_joystick_percent = 100.0
	#@right_joystick_percent = @hs1.value
	#@left_joystick_percent = @hs2.value
	@left_axis_x =   @js.axis[0]/327.67
	@left_axis_y =  -@js.axis[1]/327.67
	@right_axis_x =  @js.axis[3]/327.67
	@right_axis_y =  -@js.axis[4]/327.67

end

#Ackerman (Explicit) steering mode is selected:
def explicit
	input_joystick
#outputs (target values)
	c = (@right_axis_x/100.0)*@cMax
	v = (@left_axis_y/100.0)*@vMax
	r = 1.0/c
#(radians) steering angle of wheel 1
	theta1 = atan(@b/(r+@w))
	theta2 = 0
	theta3 = -theta1
	theta4 = atan(@b/(r-@w))
	theta5 = 0
	theta6 = -theta4


#(m/s) linear velocity of drive motor 1
	v2 = v*(r+@w)/r
	v5 = v*(r-@w)/r
	v1 = v2/cos(theta3)
	v3 = v1
	v4 = v5/cos(theta4)
	v6 = v4


#(rad/s) rotation rate of drive motor 1
	omega1 = v1/@R
	omega2 = v2/@R
	omega3 = omega1
	omega4 = v4/@R
	omega5 = v5/@R
	omega6 = omega4


	@wheels[0].angle = theta1
	@wheels[1].angle = theta2
	@wheels[2].angle = theta3
	@wheels[3].angle = theta4
	@wheels[4].angle = theta5
	@wheels[5].angle = theta6
	@wheels[0].velocity  = v1
	@wheels[1].velocity  = v2
	@wheels[2].velocity  = v3
	@wheels[3].velocity  = v4
	@wheels[4].velocity  = v5
	@wheels[5].velocity  = v6
	@wheels[0].omega = omega1
	@wheels[1].omega = omega2
	@wheels[2].omega = omega3
	@wheels[3].omega = omega4
	@wheels[4].omega = omega5
	@wheels[5].omega = omega6
end

#Vector (Crab) steering mode is selected:
def vector
	input_joystick

#(radians) steering angle of all wheels
	#theta = (@right_axis_y/100.0)*@thetaMax
	theta = atan2(@right_axis_y,@right_axis_x) - Math::PI/2
#(m/s) linear velocity of all drive wheels
	v = (@left_axis_y/100.0)*@vMax
	#v = ((@right_axis_y/100)**2.0+(@right_axis_x/100)**2.0)**0.5*@vMax
	#v = @vMax if v > @vMax
#(radians/s) rotation rate of all drive motors
	omega = v/@R

	@wheels[0].angle = theta
	@wheels[1].angle = theta
	@wheels[2].angle = theta
	@wheels[3].angle = theta
	@wheels[4].angle = theta
	@wheels[5].angle = theta
	@wheels[0].velocity  = v
	@wheels[1].velocity  = v
	@wheels[2].velocity  = v
	@wheels[3].velocity  = v
	@wheels[4].velocity  = v
	@wheels[5].velocity  = v
	@wheels[0].omega = omega
	@wheels[1].omega = omega
	@wheels[2].omega = omega
	@wheels[3].omega = omega
	@wheels[4].omega = omega
	@wheels[5].omega = omega
end


# %% Zero-Radius (In-Place) steering mode is selected:
def zeroRadius
	input_joystick


#(radians) steering angle of wheel 1
	theta1 = atan(@b/@w)
	theta2 = 0
	theta3 = -theta1
	theta4 = -theta1
	theta5 = 0
	theta6 = theta1
    

#(m/s) linear velocity of drive wheel 1
	v1 = (@left_axis_x/100.0)*@vMax*0.5
	v2 = v1*(@w/(@b**2 + @w**2)**0.5)
	v3 = v1
	v4 = -v1
	v5 = -v2
	v6 = -v1
    

#(radians/s) rotation rate of drive motor 1
	omega1 = v1/@R
	omega2 = v2/@R
	omega3 = v3/@R
	omega4 = v4/@R
	omega5 = v5/@R
	omega6 = v6/@R


	@wheels[0].angle = theta1
	@wheels[1].angle = theta2
	@wheels[2].angle = theta3
	@wheels[3].angle = theta4
	@wheels[4].angle = theta5
	@wheels[5].angle = theta6
	@wheels[0].velocity  = v1
	@wheels[1].velocity  = v2
	@wheels[2].velocity  = v3
	@wheels[3].velocity  = v4
	@wheels[4].velocity  = v5
	@wheels[5].velocity  = v6
	@wheels[0].omega = omega1
	@wheels[1].omega = omega2
	@wheels[2].omega = omega3
	@wheels[3].omega = omega4
	@wheels[4].omega = omega5
	@wheels[5].omega = omega6
end
