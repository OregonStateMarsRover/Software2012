class Joystick
	attr_accessor :axis, :button, :change, :running
	def initialize
		@axis = Array::new(8,0)
		@button = Array::new(5,0)
		@change = false
		@thread = false
	end
	def start
		pipe = IO.popen("jstest --event /dev/input/js1", "r")
		@running = true
		@thread = true
		while @running
			p = pipe.readline
			#puts p
			if m = (/^Event: type (\d+?), time (\d+?), number (\d), value (-??)(\d+?)$/).match(p)
				type = m[1].to_i
				time = m[2].to_i
				number = m[3].to_i
				value = (m[4]+m[5]).to_i
				if type == 1
					#puts "button[#{number}] = #{value}"
					@button[number] = value
				elsif type == 2
					#puts "axis[#{number}] = #{value}"
					@axis[number] = value
				end
				puts to_s
				@change = true
			end
		end
		pipe.close
		@thread = false
		puts "pipe closed"
	end

	def close
		puts "Program closing?"
		@running = false
		while @thread == true

		end
		puts "thread closed"
	end

	def to_s
		str = "Axis: "
		@axis.each_index{|index|
			str += "#{index}:#{@axis[index]} "
		}
		str += "\nButton: "
		
		@button.each_index{|index|
			str += "#{index}:#{@button[index]} "
		}
		str += "\n"
		return str
	end
end
