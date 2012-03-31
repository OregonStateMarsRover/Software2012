
require 'ruby-processing'
require 'Rover'
require 'WheelMath'
#require 'HScrollbar'

class WheelSim < Processing::App
  attr_accessor :wheels, :rover
	def setup
		setup_wheels
		setup_constants
		size(500, 500)
		smooth()
		strokeWeight(1.0)
		stroke(0, 100)
		fill(0, 102, 153)
		@hs1 = HScrollbar.new(0,400,10)
		@hs2 = HScrollbar.new(0,400,40)
		@offset_detail = {:x => 300, :y => 200}
		@drive_mode = :explicit
	end

	def setup_wheels
 		@offset = {:x => 50, :y => 200}
		@rover = Rover.instance
		@wheels = @rover.wheels
	end

	def draw
		background(226)
		pushMatrix()
		translate(@offset[:x], @offset[:y])
		connect_wheel @wheels[0], @wheels[3]
		connect_wheel @wheels[1], @wheels[2]
		connect_wheel @wheels[4], @wheels[5]
		connect @wheels[0], @wheels[3], @wheels[1], @wheels[2]
		connect @wheels[0], @wheels[3], @wheels[4], @wheels[5]
		connect @wheels[1], @wheels[2], @wheels[4], @wheels[5]
		if @drive_mode == :explicit
			explicit
		elsif @drive_mode == :vector
			vector
		elsif @drive_mode == :zeroRadius
			zeroRadius
		end

		@wheels.each{ |wheel|
			pushMatrix()
				draw_wheel(wheel)
			popMatrix()	
		}

		popMatrix()

		pushMatrix()
			details(@wheels[0])
		popMatrix()

		strokeWeight(1.0)
		@hs1.update
		@hs2.update
		@hs1.display
		@hs2.display
		display_mode
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
		line((wheel1.pos[:x] + wheel2.pos[:x])/2, (wheel1.pos[:y] + wheel2.pos[:y])/2,(wheel3.pos[:x] + wheel4.poS[:x])/2, (wheel3.pos[:y] + wheel4.pos[:y])/2)
	end

	def draw_wheel(wheel)
		strokeWeight(5.0)
		translate(wheel.pos[:x], wheel.pos[:y])
		rotate(-wheel.angle)
		heigth = 60
		width = 30
		fill(0, 102, 153)
		rect(-width/2, -heigth/2, width, heigth)
		fill(0, 0, 0)
		text("#{wheel.id-1}",0,0)
	end


	def over?
		return mouseX.between?(@pos,@pos+10) && mouseY.between?(@y,@y+10)
	end

	class HScrollbar
		attr_accessor :right, :left, :y
   
		def initialize(left,right,y)
			@right = right
			@left = left
			@y = y
			@pos = (@right + @left)/2
		end

		def value
			return (@pos*200.0)/(@right - @left)-100
		end

		def update
			@over = over?
			if mouse_pressed? && @over
				@locked = true
			end
			if !mouse_pressed?
				@locked = false
			end
			if @locked
				@pos = constrain(mouse_x,@left,@right)
			end
		end

		def constrain(val,left,right)
			return right if val > right
			return left if val < left
			return val
		end
    

		def display
			fill(255)
			rect(@left,@y,@right - @left + 10 , 10)
			fill(102, 102, 102);
			rect(@pos,@y,10,10)
			fill(0, 0, 0)
			text("#{value}",@pos,@y)
		end

		def over?
			return mouseX > @pos && mouseX < @pos+10 && mouseY > @y && mouseY < @y+10
		end
	end
end

