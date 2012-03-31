# %% Wheel designations: 

# % 1: back-left
# % 2: middle-left
# % 3: front-left
# % 4: back-right
# % 5: middle-right
# % 6: front-right

# clear all

# %% constants
# b = .381; % (m) half length of rover
b = .381
# w = .7396/2; % (m) half width of rover
w = .7396/2
# R = .232; % (m) wheel radius
R = .232
# vMax = 1.3; % (m/s) max linear speed of wheels for worst case turn and full throttle
vMax = 1.3
# cMax = 1/w -.001; % (1/m) max overall rotation curvature
cMax = 1/w -.001
# thetaMax = (3.14159/180)*140; % (radians) max steering angle of wheel
thetaMax = (3.14159/180)*140
# %% Ackerman (Explicit) steering mode is selected:

# for steering_mode = 1
def Explicit
#     % inputs (joystick positions)
#     right_joystick _percent = -75; % input right (steering) joystick left-right position: between -100 and +100
	right_joystick_percent = -75
#     left_joystick _percent = 100; % input left (speed) joystick back-front position: between -100 and 100
	left_joystick_percent = 100
#     % outputs (target values)
#     c = (right_joystick _percent./100).*cMax; % (1/m) overall rotation curvature
	c = (right_joystick _percent./100).*cMax
#     v = (left_joystick _percent./100).*vMax; % (m/s) overall velocity
	v = (left_joystick _percent./100).*vMax
#     r = 1./c; % (m) overall, instantaneous radius of curvature
	r = 1./c

#     theta1 = atan(b/(r+w)); % (radians) steering angle of wheel 1
	theta1 = atan(b/(r+w))
#     theta2 = 0;
	theta2 = 0
#     theta3 = -theta1;
	theta3 = -theta1
#     theta4 = atan(b/(r-w));
	theta4 = atan(b/(r-w))
#     theta5 = 0;
	theta5 = 0
#     theta6 = -theta4;
	theta6 = -theta4

#     theta1_degrees = (180/3.14159)*theta1; % (degrees) steering angle of wheel 1
	theta1_degrees = (180/3.14159)*theta1
#     theta2_degrees = 0;
	theta2_degrees = 0
#     theta3_degrees = (180/3.14159)*theta3;
	theta3_degrees = (180/3.14159)*theta3
#     theta4_degrees = (180/3.14159)*theta4;
	theta4_degrees = (180/3.14159)*theta4
#     theta5_degrees = 0;
	theta5_degrees = 0
#     theta6_degrees = (180/3.14159)*theta6;
	theta6_degrees = (180/3.14159)*theta6

#     v2 = v*(r+w)/r; % (m/s) linear velocity of drive motor 1
	v2 = v*(r+w)/r
#     v5 = v*(r-w)/r;
	v5 = v*(r-w)/r
#     v1 = v2/cos(theta3);
	v1 = v2/cos(theta3)
#     v3 = v1;
	v3 = v1
#     v4 = v5/cos(theta4);
	v4 = v5/cos(theta4)
#     v6 = v4;
	v6 = v4


#     omega1 = v1/R; % (rad/s) rotation rate of drive motor 1
	omega1 = v1/R
#     omega2 = v2/R;
	omega2 = v2/R
#     omega3 = omega1;
	omega3 = omega1
#     omega4 = v4/R;
	omega4 = v4/R
#     omega5 = v5/R;
	omega5 = v5/R
#     omega6 = omega4;
	omega6 = omega4
# end
end


# %% Vector (Crab) steering mode is selected:
def Vector
# for steering_mode = 2
#     % inputs (joystick positions)
#     right_joystick _percent = -75; % input right (steering) joystick left-right position: between -100 and +100
	right_joystick _percent = -75
#     left_joystick _percent = 100; % input left (speed) joystick back-front position: between -100 and +100
	left_joystick _percent = 100

#     % outputs (target values)
#     theta = (right_joystick _percent/100)*thetaMax; % (radians) steering angle of all wheels
	theta = (right_joystick _percent/100)*thetaMax
#     theta1 = theta;
	theta1 = theta
#     theta2 = theta;
	theta2 = theta
#     theta3 = theta;
	theta3 = theta
#     theta4 = theta;
	theta4 = theta
#     theta5 = theta;
	theta5 = theta
#     theta6 = theta;
	theta6 = theta

#     theta1_degrees = (180/3.14159)*theta1; % (degrees) steering angle of wheel 1
	theta1_degrees = (180/3.14159)*theta1
#     theta2_degrees = (180/3.14159)*theta2;
	theta2_degrees = (180/3.14159)*theta2
#     theta3_degrees = (180/3.14159)*theta3;
	theta3_degrees = (180/3.14159)*theta3
#     theta4_degrees = (180/3.14159)*theta4;
	theta4_degrees = (180/3.14159)*theta4
#     theta4_degrees = (180/3.14159)*theta4;
	theta4_degrees = (180/3.14159)*theta4
#     theta6_degrees = (180/3.14159)*theta6;
	theta6_degrees = (180/3.14159)*theta6

#     v = (left_joystick _percent/100)*vMax; % (m/s) linear velocity of all drive wheels
	v = (left_joystick _percent/100)*vMax

#     omega = v/R; % (radians/s) rotation rate of all drive motors
	omega = v/R
#     omega1 = omega;
	omega1 = omega
#     omega2 = omega;
	omega2 = omega
#     omega3 = omega;
	omega3 = omega
#     omega4 = omega;
	omega4 = omega
#     omega5 = omega;
	omega5 = omega
#     omega6 = omega;
	omega6 = omega
# end
end


# %% Zero-Radius (In-Place) steering mode is selected:
def ZeroRadius
# for steering_mode = 3

#     % input (joystick position)

#     left_joystick _percent = 65; % input left (speed) joystick back-front position: between -100 and +100
	left_joystick _percent = 65
    

#     % outputs (target values)

#     theta1 = atan(b/w); % (radians) steering angle of wheel 1
	theta1 = atan(b/w)
#     theta2 = 0;
	theta2 = 0
#     theta3 = -theta1;
	theta3 = -theta1
#     theta4 = -theta1;
	theta4 = -theta1
#     theta5 = 0;
	theta5 = 0
#     theta6 = theta1;
	theta6 = theta1
    

#     theta1_degrees = (180/3.14159)*theta1; % (degrees) steering angle of wheel 1
	theta1_degrees = (180/3.14159)*theta1
#     theta2_degrees = (180/3.14159)*theta2;
	theta2_degrees = (180/3.14159)*theta2
#     theta3_degrees = (180/3.14159)*theta3;
	theta3_degrees = (180/3.14159)*theta3
#     theta4_degrees = (180/3.14159)*theta4;
	theta4_degrees = (180/3.14159)*theta4
#     theta5_degrees = (180/3.14159)*theta5;
	theta5_degrees = (180/3.14159)*theta5
#     theta6_degrees = (180/3.14159)*theta6;
	theta6_degrees = (180/3.14159)*theta6
    

#     v1 = (left_joystick _percent/100)*vMax*.5; % (m/s) linear velocity of drive wheel 1
	v1 = (left_joystick _percent/100)*vMax*.5
#     v2 = v1*(w/(b^2 + w^2)^.5);
	v2 = v1*(w/(b^2 + w^2)^.5)
#     v3 = v1;
	v3 = v1
#     v4 = -v1;
	v4 = -v1
#     v5 = -v2;
	v5 = -v2
#     v6 = -v1;
	v6 = -v1
    

#     omega1 = v1/R; % (radians/s) rotation rate of drive motor 1
	omega1 = v1/R
#     omega2 = v2/R;
	omega2 = v2/R
#     omega3 = v3/R;
	omega3 = v3/R
#     omega4 = v4/R;
	omega4 = v4/R
#     omega5 = v5/R;
	omega5 = v5/R
#     omega6 = v6/R;
	omega6 = v6/R
# end
end
