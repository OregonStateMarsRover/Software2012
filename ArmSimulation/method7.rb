require 'ruby-processing'

class ArmSim < Processing::App
	
	def setup()
		@seg0 = {:length => 100, :angle=>0,  	:angle2=>0,	:pos => {:x=>300,:y=>500},	:angleLimit =>{	:min => toRad(180.0), 	:max=> toRad(180.0) }}
		@seg1 = {:length => 140, :angle=>PI/4, 	:angle2=>0,	:pos => {:x=>0,:y=>0},		:angleLimit =>{	:min => toRad(13), 	:max=>toRad(156.0) } }
		@seg2 = {:length => 130, :angle=>-PI/4,    	:angle2=>0,	:pos => {:x=>0,:y=>0},		:angleLimit =>{	:min => toRad(-182), 	:max=>toRad(22.0) }}
		@seg3 = {:length => 100, :angle=>PI/6,   	:angle2=>0,	:pos => {:x=>0,:y=>0},		:angleLimit =>{	:min => toRad(-85.0), 	:max=> toRad(94.0) }}
		@seg = [@seg0,@seg1,@seg2,@seg3]
		@endtarget = { :x=>629 , :y=>600 }
		@target = { :x=>729 , :y=>599 }
		size(1000, 1000);
		smooth(); 
		strokeWeight(20.0);
		stroke(0, 100);
		fill(0, 102, 153);
	end

	def draw()
		@angle = 0
		background(226)
		text("(#{@endtarget[:x]}, #{@endtarget[:y]})",10,40)
		text("(#{@seg3[:pos][:x]}, #{@seg3[:pos][:y]})",100,40)
		text(string(@seg[0]),10,70);
		text(string(@seg[1]),10,100);
		text(string(@seg[2]),10,130);
		text(string(@seg[3]),10,160);
		
		pushMatrix()
		drawMethod2
		
		popMatrix()
		#reachSegment(@seg[3], @endtarget)
		#reachSegment(@seg[2], @endtarget)
		#reachSegment(@seg[1], @target)
	end
	
	def drawMethod1
		translate(@seg[0][:pos][:x], @seg[0][:pos][:y])
		draw_seg(0)
		draw_seg(1)
		draw_seg(2)
		draw_seg(3)
	end	
	
	def drawMethod2
		#reachSegment(@seg[3], @endtarget)
		reachSegment(@seg[2], @endtarget)
		reachSegment(@seg[1], @target)
		translate(@seg[0][:pos][:x], @seg[0][:pos][:y])
		
		draw_seg2(0)
		draw_seg2(1)
		draw_seg2(2)
		draw_seg2(3)
	end
	
	def draw_seg(i)
		seg = @seg[i]
		draw_limit(seg)
		strokeWeight(5)
		rotate(-seg[:angle])
		@angle += seg[:angle]
		seg[:angle2] = @angle
		positionSegment(seg, @seg[i+1]) if i <3 
		line(0, 0, seg[:length] , 0)
		translate(seg[:length], 0)
	end
	
	def draw_seg2(i)
		seg = @seg[i]
	
		rotate(-seg[:angle2])
		line(0, 0, seg[:length] , 0)
		translate(seg[:length], 0)
		rotate(seg[:angle2])
		
	end
	
	def reachSegment(seg, target) 
		dx = target[:x] - seg[:pos][:x]
		dy = target[:y] - seg[:pos][:y]
		da = atan2(dy, dx) - seg[:angle2]
		seg[:angle2] +=da
		@target[:x] = target[:x] - cos(seg[:angle2]) * seg[:length]
		@target[:y] = target[:y] - sin(seg[:angle2]) * seg[:length]
	end
	
	def mousePressed
		@endtarget = {:x=>mouseX,:y=>mouseY}
	end
	
	def positionSegment(a, b) 
		b[:pos][:x] = a[:pos][:x] + cos(a[:angle2]) * a[:length]
		b[:pos][:y] = a[:pos][:y] + sin(a[:angle2]) * a[:length]
	end
	
	def draw_limit(seg)
		strokeWeight(3)
		#min
		pushMatrix()
			rotate(-seg[:angleLimit][:min])
			line(0, 0, 10, 0)
		popMatrix()
		
		#max
		pushMatrix()
			rotate(-seg[:angleLimit][:max])
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
		return "length: #{seg[:length]}     x: #{seg[:pos][:x]}     y: #{seg[:pos][:y]}     angle: #{toDeg(seg[:angle])}     angle2: #{toDeg(seg[:angle2])}"
	end
	
end
