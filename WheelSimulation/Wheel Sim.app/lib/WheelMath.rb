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
	@right_joystick_percent = @hs1.value
	@left_joystick_percent = @hs2.value
end

#Ackerman (Explicit) steering mode is selected:
def explicit
	input_joystick
#outputs (target values)
	c = (@right_joystick_percent/100.0)*@cMax
	v = (@left_joystick_percent/100.0)*@vMax
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


	@wheel2[:angle] = theta1
	@wheel3[:angle] = theta2
	@wheel4[:angle] = theta3
	@wheel5[:angle] = theta4
	@wheel6[:angle] = theta5
	@wheel7[:angle] = theta6
	@wheel2[:velo]  = v1
	@wheel3[:velo]  = v2
	@wheel4[:velo]  = v3
	@wheel5[:velo]  = v4
	@wheel6[:velo]  = v5
	@wheel7[:velo]  = v6
	@wheel2[:omega] = omega1
	@wheel3[:omega] = omega2
	@wheel4[:omega] = omega3
	@wheel5[:omega] = omega4
	@wheel6[:omega] = omega5
	@wheel7[:omega] = omega6
end

#Vector (Crab) steering mode is selected:
def vector
	input_joystick

#(radians) steering angle of all wheels
	theta = (@right_joystick_percent/100.0)*@thetaMax

#(m/s) linear velocity of all drive wheels
	v = (@left_joystick_percent/100.0)*@vMax
#(radians/s) rotation rate of all drive motors
	omega = v/@R

	@wheel2[:angle] = theta
	@wheel3[:angle] = theta
	@wheel4[:angle] = theta
	@wheel5[:angle] = theta
	@wheel6[:angle] = theta
	@wheel7[:angle] = theta
	@wheel2[:velo]  = v
	@wheel3[:velo]  = v
	@wheel4[:velo]  = v
	@wheel5[:velo]  = v
	@wheel6[:velo]  = v
	@wheel7[:velo]  = v
	@wheel2[:omega] = omega
	@wheel3[:omega] = omega
	@wheel4[:omega] = omega
	@wheel5[:omega] = omega
	@wheel6[:omega] = omega
	@wheel7[:omega] = omega
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
	v1 = (@left_joystick_percent/100.0)*@vMax*0.5
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


	@wheel2[:angle] = theta1
	@wheel3[:angle] = theta2
	@wheel4[:angle] = theta3
	@wheel5[:angle] = theta4
	@wheel6[:angle] = theta5
	@wheel7[:angle] = theta6
	@wheel2[:velo]  = v1
	@wheel3[:velo]  = v2
	@wheel4[:velo]  = v3
	@wheel5[:velo]  = v4
	@wheel6[:velo]  = v5
	@wheel7[:velo]  = v6
	@wheel2[:omega] = omega1
	@wheel3[:omega] = omega2
	@wheel4[:omega] = omega3
	@wheel5[:omega] = omega4
	@wheel6[:omega] = omega5
	@wheel7[:omega] = omega6
end
