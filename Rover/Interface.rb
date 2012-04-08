#require 'ArmSim'
#require 'WheelSim'
require 'ruby-processing'

class Interface < Processing::App
  load_library "control_panel"

  def setup
    control_panel do |c|
      c.slider :opacity
      c.slider(:app_width, 5..60, 20)
      c.menu(:options, ['one', 'two', 'three'], 'two')
      c.checkbox :paused
      c.button :reset
    end
  end
end

#$arm_sim = ArmSim.new
#$wheel_sim = WheelSim.new
