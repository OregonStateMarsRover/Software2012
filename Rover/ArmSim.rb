require 'ruby-processing'
require 'Rover'
require 'js'

__persistent__ = true
class ArmSim < Processing::App
	load_library "control_panel"
	attr_accessor :rover
	def setup
		@y_dir = 0
		@x_dir = 0
		method = :position
		if method == :velocity
			require "Velocity"
		else
			require "Position"
		end

		method_setup
		setup_options
		setup_seg
		
		@endTarget = { :x=>629 , :y=>600 }
		@target = { :x=>729 , :y=>599 }
		size(700, 500)
		smooth()
		strokeWeight(20.0)
		stroke(0, 100)
		fill(0, 102, 153)
		@js = Joystick.new
		Thread.new{
			@js.start
		}
		#frameRate()
	end

	def setup_options
		control_panel do |c|
			#c.slider :opacity
			c.slider(:stepSize, 0..15, 1)
			c.slider(:calculate, 0..10, 3)
			#c.checkbox :paused
			#c.button :reset
			c.title = "Arm Sim control panel"
    	end
	end

	def setup_seg
		@rover = Rover.instance
		#@rover = Rover.new
		#@rover.__persistent__ = true 
		@seg = @rover.arm.segments
		@counter = 0
	end

	def draw
		#if @counter == 0
			check_js()
		#	@counter = 50
		#end
		#@counter -= 1
		background(226)
		
		#display_text

		pushMatrix()
			draw_arm
		popMatrix()
		@seg[1].angle = @seg[1].angle2
		@seg[2].angle = calculate_angle(@seg[1].angle2,@seg[2].angle2);
		@seg[3].angle = calculate_angle(@seg[2].angle2,@seg[3].angle2);
	end

	def calculate_angle(angle1, angle2)
		(2 * PI - (angle1 - angle2) )% (2*PI)
	end

	def display_text
		text("(#{mouseX}, #{mouseY})",10,40)
		text("(#{@endTarget[:x]}, #{@endTarget[:y]})",300,40)
		text("(#{@seg[3].pos[:x]}, #{@seg[3].pos[:y]})",600,40)
		text(string(@seg[0]),10,70);
		text(string(@seg[1]),10,100);
		text(string(@seg[2]),10,130);
		text(string(@seg[3]),10,160);
	end
	
	def mousePressed
		@endTarget = {:x=>mouseX,:y=>mouseY}
	end
	
	def draw_limit(seg)
		strokeWeight(3)
		#min
		pushMatrix()
			rotate(-seg.angleLimit[:min])
			line(0, 0, 10, 0)
		popMatrix()
		
		#max
		pushMatrix()
			rotate(-seg.angleLimit[:max])
			line(0, 0, 10, 0)
		popMatrix()
	end
	
	def toDeg(rad)
		rad*180.0/PI
	end
	
	def toRad(deg)
		deg*PI/180.0
	end
	
	def string(seg)
		return "length: #{seg.length}     x: #{seg.pos[:x]}     y: #{seg.pos[:y]}     angle: #{toDeg(seg.angle)}     angle2: #{toDeg(seg.angle2)}"
	end
	
	def nextTarget
		if(@mode == :mouse) then
			dx = @endTarget[:x] - endPoint[:x]
			dy = @endTarget[:y] - endPoint[:y]
			angle = atan2(dy, dx)
			m = (dx**2 + dy**2)**0.5 - 1
			#if m < 0 then
			#	m = 0
			#end
			@target[:x] = @endTarget[:x] - cos(angle) * m
			@target[:y] = @endTarget[:y] - sin(angle) * m
		elsif(@mode == :key) then
			@target[:x] = @endTarget[:x]
			@target[:y] = @endTarget[:y] 
		end
	
	end

	def positionSegment(a, b) 
		b.pos[:x] = a.pos[:x] + cos(a.angle2) * a.length
		b.pos[:y] = a.pos[:y] + sin(a.angle2) * a.length
	end

	class TempSeg
		attr_accessor :pos
	end

	def endPoint
		b = TempSeg.new
		b.pos = {:x=>0,:y=>0}
		positionSegment(@seg[2], b)
		b.pos
	end
	
	def keyPressed
		@mode = :key
		@keypressed = key
		if key == 'w' then
			@endTarget[:x] = endPoint[:x]
			@endTarget[:y] = endPoint[:y] - @stepSize
		elsif key == 's' then
			@endTarget[:x] = endPoint[:x]
			@endTarget[:y] = endPoint[:y] + @stepSize
		elsif key == 'a' then
			@endTarget[:x] = endPoint[:x] - @stepSize
			@endTarget[:y] = endPoint[:y] 
		elsif key == 'd' then
			@endTarget[:x] = endPoint[:x] + @stepSize
			@endTarget[:y] = endPoint[:y] 
		end
	end
	def check_js
		if @js.change
			#@js.change = false
			@mode = :key
		
			@left_axis_x  =  @js.axis[0]/32767.0
			@left_axis_y  =  @js.axis[1]/32767.0
			@right_axis_x =  @js.axis[3]/32767.0
			@right_axis_y =  @js.axis[4]/32767.0
			@endTarget[:x] = endPoint[:x] + @stepSize * @left_axis_x
			@endTarget[:y] = endPoint[:y] + @stepSize * @left_axis_y
		end
	end
end

a = ArmSim.new
