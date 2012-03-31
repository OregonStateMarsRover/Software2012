require 'ruby-processing'
require 'Rover'
class ArmSim < Processing::App
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

		setup_seg
		
		@endTarget = { :x=>629 , :y=>600 }
		@target = { :x=>729 , :y=>599 }
		size(1000, 1000)
		smooth()
		strokeWeight(20.0)
		stroke(0, 100)
		fill(0, 102, 153)
	end

	def setup_seg
		@rover = Rover.instance 
		@seg = @rover.arm.segments
	end

	def draw
		#check_js()
		background(226)
		
		display_text

		pushMatrix()
			draw_arm
		popMatrix()

		@seg[2].angle = calculate_angle(@seg[1].angle2,@seg[2].angle2);
		@seg[3].angle = calculate_angle(@seg[2].angle2,@seg[3].angle2);
	end

	def calculate_angle(angle1, angle2)
		180 - (angle1 - angle2)
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
		@mode = :key
		@keypressed = key
		ev = joy.ev
		if ev.type == Joystick::Event::AXIS then
			if ev.num == 5 then
				if ev.val > 0 then
					@y_dir = 1
				elsif ev.val < 0 then
					@y_dir = -1
				else
					@y_dir = 0
				end
			elsif ev.num == 4 then
				if ev.val > 0 then
					@x_dir = 1
				elsif ev.val < 0 then
					@x_dir = -1
				else
					@x_dir = 0
				end
			end
		end
		
		@endTarget[:x] = endPoint[:x] + @stepSize*@x_dir
		@endTarget[:y] = endPoint[:y] + @stepSize*@y_dir
	end
end
