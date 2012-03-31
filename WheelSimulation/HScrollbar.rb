class HScrollbar
  attr_accessor :right, :left, :y
 
  def initialize(left,right,y)
    @right = right
    @left = left
    @y = y
  end

  def value
    return (@pos*200.0)/(@right - @left)-100
  end

  def update
    @over = over?
    @locked = mousePressed && @over
    if locked
      @pos = constrain(mouseX,@left,@right) 
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
    rect(@left,@y,@right - @left , 10)
    fill(102, 102, 102);
    rect(@pos,@y,10,10)
    fill(255)
    text("#{value}",@pos,@y)
  end
end