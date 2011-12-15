require 'ruby-processing'

class ArmSim < Processing::App

	def setup
		size 1000,1000
		@moving = false
		@mpos = {:x=>0,:y=>0}
		@seg0 = {:length => 10, :pos => {:x=>0,:y=>0}, :angle=>45,  :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg1 = {:length => 10, :pos => {:x=>0,:y=>0},         :angle=>0,    :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg2 = {:length => 10, :pos => {:x=>100,:y=>500},         :angle=>-30, :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg = [@seg0,@seg1,@seg2]
		smooth(); 
		strokeWeight(20.0);
		stroke(0, 100);
	end

	def draw
		background(226);
		
		reachSegment(@seg[0],mouseX,mouseY)
		reachSegment(@seg[1],@tX,@tY)
		reachSegment(@seg[2],@tX,@tY)
		
		positionSegment(@seg[2],@seg[1])
		positionSegment(@seg[1],@seg[0])
		@seg[0][:epos][:x] = @seg[0][:pos][:x] + cos(@seg[0][:angle]) * @seg[0][:length];
		@seg[0][:epos][:y] = @seg[0][:pos][:y] + cos(@seg[0][:angle]) * @seg[0][:length];
		
		drawSegment(@seg[2]);
		drawSegment(@seg[1]); 
		drawSegment(@seg[0]);
		
	end

	def reachSegment(seg,xin,yin)
		dx = xin - seg[:pos][:x]
		dy = yin - seg[:pos][:y]
		seg[:angle] = atan2(dy, dx)
		@tX = xin - cos(seg[:angle]) * seg[:length]
		@tY = yin - sin(seg[:angle]) * seg[:length]
	end
	
	def positionSegment(seg1,seg2)
		seg2[:pos][:x] = seg1[:epos][:x] = seg1[:pos][:x] + cos(seg1[:angle]) * seg1[:length];
		seg2[:pos][:y] = seg1[:epos][:y] = seg1[:pos][:y] + cos(seg1[:angle]) * seg1[:length];
	end

	def drawSegment(seg)
		drawLine(seg[:pos], seg[:epos]);
	end
	
	def drawLine(p1,p2)
		line(p1[:x], p1[:y] , p2[:x], p2[:y]);
	end
	
	def drawForce(p1,d1)
		p2 = {}
		p2[:x] = p1[:x]+d1[:x]
		p2[:y] = p1[:y]+d1[:y]
		drawLine(p1,p2)
	end
	
	def degToRad(deg)
		deg*PI/180
	end
	
	
	def endpoint(seg)
		angle = degToRad(seg[:angle])
		p = {:x=> 0, :y =>0 }
		p[:x] = seg[:pos][:x]+cos(angle)*seg[:length]*10
		p[:y] = seg[:pos][:y]-sin(angle)*seg[:length]*10
		return p
	end
	
	def mousePressed
		puts "mouse pressed"
		@moving = true
		@mpos = {:x=>mouseX,:y=>mouseY}
	end
	
	def move(seg)
		if @moving then
			strokeWeight(5);
			f = {:x => (@mpos[:x]-seg[:epos][:x]), :y => (@mpos[:y]-seg[:epos][:y])}
			drawForce(seg[:epos],f)
			r = {:x => (seg[:epos][:y]-seg[:pos][:y]), :y => (-seg[:epos][:x]+seg[:pos][:x])}
			drawForce(seg[:epos],r)
		end
		
	end
	
	def angle(p)
		atan(p[:y]/p[:x])*180/PI
	end
	

end

ArmSim.new :title => "ArmSim"