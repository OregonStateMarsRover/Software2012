require 'ruby-processing'

class ArmSim < Processing::App
	
	def setup()
		#setting up variables
		@options = {:rateChange => 1, :rules => true} #user changed variable
		@mpos = {:x => 0, :y => 0} # last mouse click pos
		@targetX = 0 #
		@targetY = 0
		@keypressed = 0
		@mode = :key
		@endTarget = {:x=>600, :y=>200}
		@target = {:x=>0, :y=>0}
		@seg0 = {:length => 100, :pos => {:x=>0,:y=>0}, 		:angle=>0,  :epos => {:x=>0,:y=>0}, :rpm => 1 , :angleLimit =>{:min => toRad(95.0), :max=> toRad(274.0) }}
		@seg1 = {:length => 130, :pos => {:x=>0,:y=>0},         	:angle=>0,    :epos => {:x=>0,:y=>0}, :rpm => 1 , :angleLimit =>{:min => toRad(-2.0), :max=>toRad(202.0) }}
		@seg2 = {:length => 140, :pos => {:x=>200,:y=>500},	:angle=>-PI/4, :epos => {:x=>0,:y=>0}, :rpm => 1 , :angleLimit =>{:min => toRad(13.0), :max=>toRad(156.0) } }
		@seg3 = {:length => 100, :pos => {:x=>300,:y=>500}, 	:angle=>PI,  :epos => {:x=>200,:y=>500}, :rpm => 0 , :angleLimit =>{:min => toRad(180.0), :max=> toRad(180.0) }}
		@seg = [@seg0,@seg1,@seg2,@seg3]
		size(1000, 1000);
		smooth(); 
		strokeWeight(20.0);
		stroke(0, 100);
		fill(0, 102, 153);
		#frameRate(1);
	end

	def draw() 
		background(226)
		
		rulesOption
  
  
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
		
		drawLimit(@seg[0], @seg[1])
		drawLimit(@seg[1], @seg[2])
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
		text("(#{mouseX} , #{mouseY})",400,160);
		
	end

	def positionSegment(a, b) 
		b[:pos][:x] = a[:epos][:x] = a[:pos][:x] + cos(a[:angle]) * a[:length]
		b[:pos][:y] = a[:epos][:y] = a[:pos][:y] + sin(a[:angle]) * a[:length]
	end

	def reachSegment(seg, t, seg2) 
		dx = t[:x] - seg[:pos][:x]
		dy = t[:y] - seg[:pos][:y]
		da = atan2(dy, dx) - seg[:angle]
		if @options[:rules] then
			r = rateDa(seg,seg2,da)
			da *= r
			drawData(seg,seg2,r,da)
		end
		
		seg[:angle] += da
		#if seg[:angle] < seg[:angleLimit][:min] then
		#	seg[:angle] = seg[:angleLimit][:min]
		#end
		#if seg[:angle] > seg[:angleLimit][:max] then
		#	seg[:angle] = seg[:angleLimit][:max]
		#end
		@target[:x] = t[:x] - cos(seg[:angle]) * seg[:length]
		@target[:y] = t[:y] - sin(seg[:angle]) * seg[:length]
	end

	def toRad(deg)
		deg*PI/180.0
	end
	
	def rulesOption
		fill(255, 255, 255);
		rect(12, 13, 67, 15)
		fill(0, 102, 153);
		text("Rules: #{@options[:rules]}",15,25)
	end

	def drawData(seg,seg2,rate,da)
		if mouseX < seg[:pos][:x] + 5 and mouseX > seg[:pos][:x] - 5 then
			if mouseY < seg[:pos][:y] + 5 and mouseY > seg[:pos][:y] - 5 then
				text(sprintf("Angle from segment: %0.02f", angle(seg,seg2)),seg[:pos][:x],seg[:pos][:y])
				text(sprintf("Angle from hor: %0.02f", seg[:angle]*-180/PI),seg[:pos][:x],seg[:pos][:y]+10)
				text(sprintf("Angle limit: %0.02f to %0.02f", seg[:angleLimit][:min]*180/PI,seg[:angleLimit][:max]*180/PI),seg[:pos][:x],seg[:pos][:y]+20)
				text(sprintf("rate of change: %0.02f", rate),seg[:pos][:x],seg[:pos][:y]+30)
				text(sprintf("change in angle: %0.02f", da),seg[:pos][:x],seg[:pos][:y]+40)
			end
		end
	end
	
	def rateDa(seg,seg2,da)
		h = seg[:angleLimit][:max]
		l = seg[:angleLimit][:min] 
		a = toRad(angle(seg,seg2))
		if da == da.abs and a < (h+l)/2 then
			return 1
		elsif -1*da == da.abs and a > (h+l)/2 then
			return 1
		end
		r = 1 - ((h+l-2*a)/(h-l))**2
		if r < 0 then
			r = 0
		end
		return r
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
		rotate(-seg1[:angleLimit][:max])
		line(0, 0, 10, 0)
		popMatrix()
		
		#min
		pushMatrix()
		rotate(-seg1[:angleLimit][:min])
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
			dx = @endTarget[:x] - @seg[0][:epos][:x]
			dy = @endTarget[:y] - @seg[0][:epos][:y]
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
	
	def mousePressed
		if mouseX.between?(12,79) and mouseY.between?(13,28) then
			@options[:rules] = ! @options[:rules]
		else
			@mode = :mouse
			@endTarget = {:x=>mouseX,:y=>mouseY}
			@mpos = {:x=>mouseX,:y=>mouseY}
		end
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
