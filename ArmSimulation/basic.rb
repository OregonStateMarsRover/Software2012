require 'ruby-processing'

class ArmSim < Processing::App

	def setup
		size 1000,1000
		@moving = false
		@mpos = {:x=>0,:y=>0}
		@seg0 = {:length => 10, :pos => {:x=>100,:y=>500}, :angle=>45,  :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg1 = {:length => 10, :pos => {:x=>0,:y=>0},         :angle=>0,    :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg2 = {:length => 10, :pos => {:x=>0,:y=>0},         :angle=>-30, :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg = [@seg0,@seg1,@seg2]
		smooth(); 
		strokeWeight(20.0);
		stroke(0, 100);
	end

	def draw
		background(226);
		
		move(@seg[0])
		move(@seg[1])
		move(@seg[2])
		#@moving = false
		@seg[1][:pos] = @seg[0][:epos] = endpoint(@seg[0])
		@seg[2][:pos] = @seg[1][:epos] = endpoint(@seg[1])
		@seg[2][:epos] = endpoint(@seg[2])
		
		strokeWeight(20.0);
		fill(0,0,0)
		drawSegment(@seg[0]);
		drawSegment(@seg[1]); 
		drawSegment(@seg[2]);
		
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