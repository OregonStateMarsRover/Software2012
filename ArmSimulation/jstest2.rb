#!/usr/bin/ruby

require 'joystick'

# make sure a device was specified on the command-line
unless ARGV.size > 0
  $stderr.puts 'Missing device name.'
  exit -1
end

# open the joystick device
joy = Joystick::Device.open(ARGV[0])
  # print out joystick information
  puts "Joystick: #{joy.name}", 
       "Axes / Buttons : #{joy.axes} / #{joy.buttons}",
       ''

  # loop forever
	@y_dir = 0
	@x_dir = 0
  loop {
		ev = joy.ev
    if ev.type == Joystick::Event::AXIS then
				if ev.num == 5 then
					if ev.val.to_i > 0 then
						@y_dir = 1
					elsif ev.val.to_i < 0 then
						@y_dir = -1
					else
						@y_dir = 0
					end
				elsif ev.num == 4 then
					if ev.val > 0 then
						@x_dir = 1
					elsif ev.val < 0 then
						@x_dir = -1
					else
						@x_dir = 0
					end
				end
			puts "#{@y_dir} #{@x_dir}"
		end
	}
