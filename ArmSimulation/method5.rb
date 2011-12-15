require 'ruby-processing'

class ArmSim < Processing::App
	
	def setup() 
		@targetX = 0
		@targetY = 0
		@seg0 = {:length => 100, :pos => {:x=>0,:y=>0}, 			:angle=>45,  :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg1 = {:length => 130, :pos => {:x=>0,:y=>0},         	:angle=>0,    :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg2 = {:length => 140, :pos => {:x=>200,:y=>500},	:angle=>-30, :epos => {:x=>0,:y=>0}, :rpm => 1 }
		@seg = [@seg0,@seg1,@seg2]
		size(1000, 1000);
		smooth(); 
		strokeWeight(20.0);
		stroke(0, 100);
	end

	def draw() 
		background(226)
  
		reachSegment(@seg[0], mouseX, mouseY)
		1.upto(2){|i|
			reachSegment(@seg[i], @targetX, @targetY)
		}
		(2).downto(1){ |i|
			positionSegment(@seg[i], @seg[i-1])
		}
		0.upto(2){|i|
			segment(@seg[i], (i+4)*2)
		}
	end

	def positionSegment(a, b) 
		b[:pos][:x] = a[:epos][:x] = a[:pos][:x] + cos(a[:angle]) * a[:length]
		b[:pos][:y] = a[:epos][:x] = a[:pos][:y] + sin(a[:angle]) * a[:length]
	end

	def reachSegment(seg, xin, yin) 
		dx = xin - seg[:pos][:x]
		dy = yin - seg[:pos][:y]
		seg[:angle]= atan2(dy, dx)
		@targetX = xin - cos(seg[:angle]) * seg[:length]
		@targetY = yin - sin(seg[:angle]) * seg[:length]
	end

	def segment( seg, sw) 
		strokeWeight(sw)
		pushMatrix()
		translate(seg[:pos][:x], seg[:pos][:y])
		rotate(seg[:angle])
		line(0, 0, seg[:length], 0)
		popMatrix()
	end

end

ArmSim.new :width => 1000, :height => 1000, :title => "Francis's Arm Simulation"
