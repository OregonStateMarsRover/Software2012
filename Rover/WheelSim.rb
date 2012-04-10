
require 'ruby-processing'
require 'Rover'
require 'WheelMath'
require 'js'
#require 'HScrollbar'

class WheelSim < Processing::App
	load_library "control_panel"
	attr_accessor :wheels, :rover, :js, :cp
	def setup
		setup_wheels
		setup_constants
		setup_options
		size(500, 300)
		smooth()
		strokeWeight(1.0)
		stroke(0, 100)
		fill(0, 102, 153)
		@offset_detail = {:x => 300, :y => 50}
		@drive_mode = "explicit"
		@js = Joystick.new
		Thread.new{
			@js.start
		}
		@cp = control_panel
	end

	def setup_options
		control_panel do |c|
      		#c.slider :opacity
      		c.slider(:vMax, 0..1.7, 1.3)
      		c.slider(:camera_speed, 0..4, 1)
      		c.menu(:drive_mode, ["explicit","vector","zeroRadius"], "explicit")
      		c.menu(:button1, ["explicit","vector","zeroRadius"], "explicit")
      		c.menu(:button2, ["explicit","vector","zeroRadius"], "vector")
      		c.menu(:button3, ["explicit","vector","zeroRadius"], "zeroRadius")
      		#c.checkbox :paused
      		#c.button :reset
      		c.title = "Wheel Sim control panel"
    	end
	end

	def setup_wheels
 		@offset = {:x => 50, :y => 50}
		@rover = Rover.instance
		@wheels = @rover.wheels
		@camera = @rover.tripod
		@camera.pos = {:x => @offset[:x]+100 , :y => @offset[:y]}
		@current_wheel = @wheels[0] 
	end



	def draw
		#puts @js.to_s
		background(226)
		pushMatrix()
		translate(@offset[:x], @offset[:y])
		connect_wheel @wheels[0], @wheels[3]
		connect_wheel @wheels[1], @wheels[2]
		connect_wheel @wheels[4], @wheels[5]
		connect @wheels[0], @wheels[3], @wheels[1], @wheels[2]
		connect @wheels[0], @wheels[3], @wheels[4], @wheels[5]
		connect @wheels[1], @wheels[2], @wheels[4], @wheels[5]
		mode_check
		if @drive_mode == "explicit"
			@cp.elements[2].set_selected_index(0)
			explicit
		elsif @drive_mode == "vector"
			@cp.elements[2].set_selected_index(1)
			vector
		elsif @drive_mode == "zeroRadius"
			@cp.elements[2].set_selected_index(2)
			zeroRadius
		end

		@wheels.each{ |wheel|
			pushMatrix()
				draw_wheel(wheel)
			popMatrix()
			if over_wheel? wheel
				@current_wheel = wheel
			end 
		}

		popMatrix()

		pushMatrix()
			#puts over_camera?
			update_camera
			draw_camera
		popMatrix()

		pushMatrix()
			details(@current_wheel)
		popMatrix()

		strokeWeight(1.0)
		#display_mode
	end

	def mode_check
		if @js.button[1] == 1
			@drive_mode = @button1
		end
		if @js.button[2] == 1
			@drive_mode = @button2
		end
		if @js.button[3] == 1
			@drive_mode = @button3
		end
		
	end

	def draw_camera
		strokeWeight(3)
		line(@offset[:x]+100, @offset[:y]+100, @camera.pos[:x],@camera.pos[:y] )
		strokeWeight(0)
		ellipse(@camera.pos[:x],@camera.pos[:y],10,10)
		translate(@offset[:x]+100, @offset[:y]+100)
		rotate(-@camera.angle)
		strokeWeight(0)
		fill(0, 102, 153)
		rect(-20, -15, 40, 30)
		rect(-10, -25, 20, 30)
		strokeWeight(5)
	end

	def over_camera?
		if 5 > ((mouseX - @camera.pos[:x])**2 + (mouseY - @camera.pos[:y])**2) ** 0.5
			return true
		end

		return false
	end

	def update_camera
		if mouse_pressed? && over_camera?
			@locked = true
		end
		if !mouse_pressed?
			@locked = false
		end
		h = @camera.zoom*100+40
		move_camera h
		if @locked
			dx = (@offset[:x]+100) - mouseX
			dy = (@offset[:y]+100) - mouseY
			@camera.angle = atan2(dx, dy)
			h = (dx**2 + dy**2)**0.5
			h = constrain(h,40,140)
		end
		h += (@js.axis[2]+32767)/(327.67*2)/100
		h -= (@js.axis[5]+32767)/(327.67*2)/100
		h = constrain(h,40,140)
		@camera.zoom = (h-40.0)/100.0
		@camera.pos[:x] = -sin(@camera.angle) * h + @offset[:x]+100
		@camera.pos[:y] = -cos(@camera.angle) * h + @offset[:y]+100
	end

	def move_camera h
		@camera.angle -= (@js.axis[6]/32767.0)*@camera_speed/h
	end

	def constrain(val,left,right)
      return right if val > right
      return left if val < left
      return val
    end

	def update_camera_angle
		dx = (@offset[:x]+100) - @camera.pos[:x]
		dy = (@offset[:y]+100) - @camera.pos[:y]
		atan2(dx, dy)
	end

	def display_mode
		fill(0, 102, 153)

		if @drive_mode == :explicit
			fill(0, 0, 0)
		end
		rect(25,85,20,20)

		fill(0, 102, 153)
		if @drive_mode == :vector
			fill(0, 0, 0)
		end  
		rect(125,85,20,20)
    
		fill(0, 102, 153)
		if @drive_mode == :zeroRadius
			fill(0, 0, 0)
		end  
		rect(225,85,20,20)

		fill(0, 0, 0)
		text("explicit",50,100)
		text("vector",150,100)
		text("zero radius",250,100)
	end

	def mouse_pressed
		if !mouse_y.between?(85,85+20)
			return
		end

		if mouse_x.between?(25,45)
			@drive_mode = :explicit
		end
		if mouse_x.between?(125,145)
			@drive_mode = :vector
		end
		if mouse_x.between?(225,245)
			@drive_mode = :zeroRadius
		end
	end

	def details(wheel)
		translate(@offset_detail[:x], @offset_detail[:y])
		text("Wheel #{wheel.id-1}",0,0)
		text("Package ID: #{wheel.id}",0,33)
		text("Angle - theta: #{wheel.angle}",0,66)
		text("Angle - theta: #{wheel.angle*180/PI}",0,100)
		text("Velocity: #{wheel.velocity}",0,133)
		text("Rotation Rate - Omega: #{wheel.omega}",0,166)
		text("Rotation Rate - Omega: #{wheel.omega*180/PI}",0,200)
	end

	def connect_wheel(wheel1, wheel2)
		strokeWeight(10.0)
		line(wheel1.pos[:x], wheel1.pos[:y],wheel2.pos[:x], wheel2.pos[:y])
	end

	def connect(wheel1, wheel2, wheel3, wheel4)
		strokeWeight(10.0)
		line((wheel1.pos[:x] + wheel2.pos[:x])/2, (wheel1.pos[:y] + wheel2.pos[:y])/2,(wheel3.pos[:x] + wheel4.pos[:x])/2, (wheel3.pos[:y] + wheel4.pos[:y])/2)
	end

	def draw_wheel(wheel)
		strokeWeight(5.0)
		translate(wheel.pos[:x], wheel.pos[:y])
		rotate(-wheel.angle)
		heigth = 60
		width = 30
		fill(255)
		rect(-width/2, -heigth/2, width, heigth)
		strokeWeight(0)
		fill(0, 102, 153)
		rect(-width/2, 0, width, heigth*(wheel.velocity/@vMax)*0.5)
		strokeWeight(5.0)
		fill(0, 0, 0)
		text("#{wheel.id-1}",0,0)
	end


	def over_wheel?(wheel)
		return mouse_x.between?(wheel.pos[:x]-15+@offset[:x],wheel.pos[:x]+15+@offset[:x]) && mouse_y.between?(wheel.pos[:y]-15+@offset[:y],wheel.pos[:y]+15+@offset[:y])
	end

end
