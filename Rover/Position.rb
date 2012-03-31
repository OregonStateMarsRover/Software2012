
def method_setup
	@stepSize = 1
	@calculate = 20
end

def draw_arm
	
	1.upto(3) { |i|
		positionSegment(@seg[i-1], @seg[i])
	}
	
	nextTarget()
	@calculate.times {
		reachSegment(@seg[2], @endTarget)
		reachSegment(@seg[1], @target)	
	}
	translate(@seg[0].pos[:x], @seg[0].pos[:y])
	
	strokeWeight(10)
	draw_seg(0)
	draw_seg(1)
	draw_seg(2)
	draw_seg(3)
end

def draw_seg(i)
	strokeWeight(10)
	seg = @seg[i]

	rotate(seg.angle2)
	line(0, 0, seg.length , 0)
	translate(seg.length, 0)
	draw_limit(@seg[i+1]) if (i < 3)
	rotate(-seg.angle2)
end

def reachSegment(seg, target) 
	dx = target[:x] - seg.pos[:x]
	dy = target[:y] - seg.pos[:y]
	da = atan2(dy, dx) - seg.angle2
	seg.angle2 +=da
	@target[:x] = target[:x] - cos(seg.angle2) * seg.length
	@target[:y] = target[:y] - sin(seg.angle2) * seg.length
end
