require 'ruby-processing'
class ArmSim < Processing::App
def setup() 
@numSegments = 3
@x = []
@y = []
@angle = []
@segLength = 100
@targetX = 0
@targetY = 0

  size(1000, 1000);
  smooth(); 
  strokeWeight(20.0);
  stroke(0, 100);
  0.upto(@numSegments - 1){|i|
	@x[i] = 0
	@y[i] = 0
  }
  @x[@numSegments - 1] = 200
  @y[@numSegments - 1] = 500
end

def draw() 
  background(226)
  
  reachSegment(0, mouseX, mouseY)
  1.upto(@numSegments-1){|i|
    reachSegment(i, @targetX, @targetY)
  }
  (@numSegments-1).downto(1){ |i|
    positionSegment(i, i-1)
  }
  0.upto(@numSegments-1){|i|
    segment(@x[i], @y[i], @angle[i], (i+4)*2)
  }
end

def positionSegment(a, b) 
  @x[b] = @x[a] + cos(@angle[a]) * @segLength
  @y[b] = @y[a] + sin(@angle[a]) * @segLength;
end

def reachSegment(i, xin, yin) 
  dx = xin - @x[i]
  dy = yin - @y[i]
  @angle[i] = atan2(dy, dx)
  @targetX = xin - cos(@angle[i]) * @segLength
  @targetY = yin - sin(@angle[i]) * @segLength
end

def segment( x, y, a, sw) 
  strokeWeight(sw)
  pushMatrix()
  translate(x, y)
  rotate(a)
  line(0, 0, @segLength, 0)
  popMatrix()
end

end

ArmSim.new :width => 500, :height => 500, :title => "Francis's Arm Simulation"
