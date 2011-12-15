require 'ruby-processing'

class ArmSim < Processing::App
	
	def setup() 
		@mpos = {:x => 0, :y => 0}
		@targetX = 0
		@targetY = 0
		@keypressed = 0 
		@endTarget = {:x=>0, :y=>0}
		@target = {:x=>0, :y=>0}
		@seg0 = {:length => 100, :pos => {:x=>0,:y=>0}, 		:angle=>-PI/4,  :epos => {:x=>0,:y=>0}, :rpm => 1 , :angleLimit =>{:min => 95.0, :max=> 274.0 }}
		@seg1 = {:length => 130, :pos => {:x=>0,:y=>0},         	:angle=>-PI/4,    :epos => {:x=>0,:y=>0}, :rpm => 1 , :angleLimit =>{:min => -2.0, :max=>202.0 }}
		@seg2 = {:length => 140, :pos => {:x=>200,:y=>500},	:angle=>-PI/4, :epos => {:x=>0,:y=>0}, :rpm => 1 , :angleLimit =>{:min => 13.0, :max=>156.0 } }
		@seg3 = {:length => 100, :pos => {:x=>300,:y=>500}, 	:angle=>PI,  :epos => {:x=>200,:y=>500}, :rpm => 0 , :angleLimit =>{:min => 180.0, :max=> 180.0 }}
		@seg = [@seg0,@seg1,@seg2,@seg3]
		size(1000, 1000);
		smooth(); 
		strokeWeight(20.0);
		stroke(0, 100);
		#frameRate(5);
	end

	def draw() 
		background(226)
  
  
		nextTarget()
  
		reachSegment(@seg[0], @target,@seg[1])
		#reachSegment(@seg[0], mouseX, mouseY)
		1.upto(2){|i|
			reachSegment(@seg[i], @target,@seg[i+1])
		}
		(3).downto(1){ |i|
			positionSegment(@seg[i], @seg[i-1])
		}
		@seg[0][:epos][:x] = @seg[0][:pos][:x] + cos(@seg[0][:angle]) * @seg[0][:length]
		@seg[0][:epos][:y] = @seg[0][:pos][:y] + sin(@seg[0][:angle]) * @seg[0][:length]
		0.upto(3){|i|
			segment(@seg[i], (i+4)*2)
		}
		
		#drawLimit(@seg[0], @seg[1])
		#drawLimit(@seg[1], @seg[2])
		drawLimit(@seg[2], @seg[3])
		
		#print angle in respect to other segment
		text(sprintf("Angle at Joint 1: %0.02f", angle(@seg[2],@seg[3])),10,100);
		text(sprintf("Angle at Joint 2: %0.02f", angle(@seg[1],@seg[2])),10,130);
		text(sprintf("Angle at Joint 3: %0.02f", angle(@seg[0],@seg[1])),10,160);
		
		#print angle in respect to hor
		text(sprintf("Angle at Joint 1: %0.02f", @seg[2][:angle]*-180/PI),200,100);
		text(sprintf("Angle at Joint 2: %0.02f", @seg[1][:angle]*-180/PI),200,130);
		text(sprintf("Angle at Joint 3: %0.02f", @seg[0][:angle]*-180/PI),200,160);
		
		text("(#{ endPoint[:x] } , #{ endPoint[:y] }}",400,100);
		text("(#{@endTarget[:x]} , #{@endTarget[:y]})",400,130);
	end

	def positionSegment(a, b) 
		b[:pos][:x] = a[:epos][:x] = a[:pos][:x] + cos(a[:angle]) * a[:length]
		b[:pos][:y] = a[:epos][:y] = a[:pos][:y] + sin(a[:angle]) * a[:length]
	end

	def reachSegment(seg, t, seg2) 
		dx = t[:x] - seg[:pos][:x]
		dy = t[:y] - seg[:pos][:y]
		da = atan2(dy, dx) - seg[:angle]
		h = seg[:angleLimit][:max]
		l = seg[:angleLimit][:min]
		b = -4.0/(h**2 + 6.0*h*l + l**2)
		rate = b* ( angle(seg,seg2) - (h+l)/2 )**2 +1
		if rate <= 0 then
			rate = 0
		end
		seg[:angle] += da*rate
		@target[:x] = t[:x] - cos(seg[:angle]) * seg[:length]
		@target[:y] = t[:y] - sin(seg[:angle]) * seg[:length]
	end

	def segment( seg, sw) 
		strokeWeight(sw)
		#pushMatrix()
		#translate(seg[:pos][:x], seg[:pos][:y])
		#rotate(seg[:angle])
		#line(0, 0, seg[:length], 0)
		#popMatrix()
		line(seg[:pos][:x], seg[:pos][:y], seg[:epos][:x], seg[:epos][:y])
	end

	def drawLimit(seg1,seg2)
		strokeWeight(3)
		pushMatrix()
		translate(seg2[:epos][:x], seg2[:epos][:y])
		rotate(seg2[:angle]-PI)
		#max
		pushMatrix()
		rotate(-seg1[:angleLimit][:max]*PI/180)
		line(0, 0, 10, 0)
		popMatrix()
		
		#min
		pushMatrix()
		rotate(-seg1[:angleLimit][:min]*PI/180)
		line(0, 0, 10, 0)
		popMatrix()
		
		popMatrix()
	end
	
	def angle(a,b)
		aa = -a[:angle]*180.0/PI
		ab = -b[:angle]*180.0/PI
		(180-ab+aa)%360
	end
	
	def nextTarget
		if(@mode == :mouse) then
			dx = @mpos[:x] - @seg[0][:epos][:x]
			dy = @mpos[:y] - @seg[0][:epos][:y]
			angle = atan2(dy, dx)
			m = (dx**2 + dy**2)**0.5 - 1
			@target[:x] = @endTarget[:x] - cos(angle) * m
			@target[:y] = @endTarget[:y] - sin(angle) * m
		elsif(@mode == :key) then
			@target[:x] = @endTarget[:x]
			@target[:y] = @endTarget[:y]
		end
	
	end
	
	def mousePressed
		@mode = :mouse
		@endTarget = {:x=>mouseX,:y=>mouseY}
		@mpos = {:x=>mouseX,:y=>mouseY}
	end
	
	def endPoint
		@seg[0][:epos]
	end

	def keyPressed
		@mode = :key
		@keypressed = key
		if key == 'w' then
			@endTarget[:x] = endPoint[:x]
			@endTarget[:y] = endPoint[:y] - 1
		elsif key == 's' then
			@endTarget[:x] = endPoint[:x]
			@endTarget[:y] = endPoint[:y] + 1
		elsif key == 'a' then
			@endTarget[:x] = endPoint[:x] - 1
			@endTarget[:y] = endPoint[:y] 
		elsif key == 'd' then
			@endTarget[:x] = endPoint[:x] + 1
			@endTarget[:y] = endPoint[:y] 
		end
	end

end

ArmSim.new :width => 1000, :height => 1000, :title => "Francis's Arm Simulation"
