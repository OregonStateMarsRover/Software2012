
require 'ruby-processing'
require 'WheelMath'
#require 'HScrollbar'

class WheelSim < Processing::App
	def setup
		setup_wheels
		setup_constants
		size(500, 500)
		smooth()
		strokeWeight(1.0)
		stroke(0, 100)
		fill(0, 102, 153)
		@hs1 = HScrollbar.new(0,400,10)
		@hs2 = HScrollbar.new(0,400,40)
	end

	def setup_wheels
		@wheel2 = {:id => 2, :angle => 0, :velo => 0, :y => 400 , :x => 100, :omega => 0}
		@wheel3 = {:id => 3, :angle => 0, :velo => 0, :y => 300 , :x => 100, :omega => 0}
		@wheel4 = {:id => 4, :angle => 0, :velo => 0, :y => 200 , :x => 100, :omega => 0}
		@wheel5 = {:id => 5, :angle => 0, :velo => 0, :y => 400 , :x => 300, :omega => 0}
		@wheel6 = {:id => 6, :angle => 0, :velo => 0, :y => 300 , :x => 300, :omega => 0}
		@wheel7 = {:id => 7, :angle => 0, :velo => 0, :y => 200 , :x => 300, :omega => 0}
		@wheels = [@wheel2,@wheel3,@wheel4,@wheel5,@wheel6,@wheel7]
	end

	def draw
		background(226)
		connect_wheel @wheel2, @wheel5
		connect_wheel @wheel3, @wheel4
		connect_wheel @wheel6, @wheel7
		connect @wheel2, @wheel5, @wheel3, @wheel4
		connect @wheel2, @wheel5, @wheel6, @wheel7
		connect @wheel3, @wheel4, @wheel6, @wheel7
		#explicit
		vector
		#zeroRadius
		@wheels.each{ |wheel|
			pushMatrix()
				draw_wheel(wheel)
			popMatrix()	
		}

		strokeWeight(1.0)
		@hs1.update
  		@hs2.update
  		@hs1.display
  		@hs2.display
	end

	def connect_wheel(wheel1, wheel2)
		strokeWeight(10.0)
		line(wheel1[:x], wheel1[:y],wheel2[:x], wheel2[:y])
	end

	def connect(wheel1, wheel2, wheel3, wheel4)
		strokeWeight(10.0)
		line((wheel1[:x] + wheel2[:x])/2, (wheel1[:y] + wheel2[:y])/2,(wheel3[:x] + wheel4[:x])/2, (wheel3[:y] + wheel4[:y])/2)
	end

	def draw_wheel(wheel)
		strokeWeight(5.0)
		translate(wheel[:x], wheel[:y])
		rotate(-wheel[:angle])
		heigth = 60
		width = 30
		fill(0, 102, 153)
		rect(-width/2, -heigth/2, width, heigth)
		fill(0, 0, 0)
		text("#{wheel[:id]-1}",0,0)
	end


  def over?
  	return mouseX > @pos && mouseX < @pos+10 && mouseY > @y && mouseY < @y+10
  end

  class HScrollbar
    attr_accessor :right, :left, :y
   
    def initialize(left,right,y)
      @right = right
      @left = left
      @y = y
      @pos = (@right + @left)/2
    end

    def value
      return (@pos*200.0)/(@right - @left)-100
    end

    def update
      @over = over?
      if mouse_pressed? && @over
      	@locked = true
      end
      if !mouse_pressed?
      	@locked = false
      end
      #puts @locked
      if @locked
        @pos = constrain(mouse_x,@left,@right)
      end
    end

    def constrain(val,left,right)
      return right if val > right
      return left if val < left
      return val
    end
    
    #def over?
    #  return mouseX > @pos && mouseX < @pos+10 && mouseY > @y && mouseY < @y+10
    #end

    def display
      fill(255)
      rect(@left,@y,@right - @left + 10 , 10)
      fill(102, 102, 102);
      rect(@pos,@y,10,10)
      fill(0, 0, 0)
      text("#{value}",@pos,@y)
    end

    def over?
    	#puts "#{mouseX} #{mouseY} #{@pos} #{@y}"
      #return false
      return mouseX > @pos && mouseX < @pos+10 && mouseY > @y && mouseY < @y+10
    end
  end



end	
