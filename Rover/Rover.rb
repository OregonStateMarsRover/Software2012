require 'singleton'
class Rover
	include Singleton
	attr_accessor :arm, :tripod, :wheels, :mainboard
	def initialize
		@arm = Arm.new
		@tripod = Tripod.new
		@wheels = []
		@wheels << Wheel.new(2,{:x => 000, :y => 200})
		@wheels << Wheel.new(3,{:x => 000, :y => 100})
		@wheels << Wheel.new(4,{:x => 000, :y => 000})
		@wheels << Wheel.new(5,{:x => 200, :y => 200})
		@wheels << Wheel.new(6,{:x => 200, :y => 100})
		@wheels << Wheel.new(7,{:x => 200, :y => 000})
		@mainboard = Mainboard.new
	end

	class Arm
		include Math
		attr_accessor :id, :encoders, :actuators, :probe, :voltage, :segments
		def initialize
			@id = 8
			@encoders = [Encoder.new(100),Encoder.new(100)]
			@actuators  = [Actuator.new, Actuator.new]
			@probe = Probe.new
			@voltage = Voltage.new
			seg0 = Segment.new(100,0,{:x=>200,:y=>300},{:min=>toRad(180.0), :max=>toRad(180.0)})
			seg1 = Segment.new(140,PI/4,{:x=>0,:y=>0},{:min=>toRad(13.0), :max=>toRad(156.0)})
			seg2 = Segment.new(130,-PI/4,{:x=>0,:y=>0},{:min=>toRad(-182.0), :max=>toRad(22.0)})
			seg3 = Segment.new(100,PI/6,{:x=>0,:y=>0},{:min=>toRad(-85.0), :max=>toRad(94.0)})
			@segments = [seg0,seg1,seg2,seg3]
		end

		def toRad(deg)
			deg*PI/180.0
		end

		class Segment
			attr_accessor :length, :angle, :angle2, :pos, :angleLimit
			def initialize(length,angle,pos,angleLimit)
				@length = length
				@angle = angle
				@angle2 = 0
				@pos = pos
				@angleLimit = angleLimit
			end
		end

		class Probe
			attr_accessor :data
		end

		class Voltage
			attr_accessor :value
		end

	end

	class Tripod
		attr_accessor :actuators, :zoom, :pos
		def initialize

			@actuators  = [Actuator.new, Actuator.new]
			@zoom = 0.5
			@pos = {:x => 50+100 , :y => 50}
		end
	end

	class Wheel
		attr_accessor :id, :angle, :velocity, :omega, :pos
		def initialize(id, pos)
			@id = id
			@angle = 0
			@velocity = 0
			@omega = 0

			@pos = pos
		end

	end

	class Mainboard
		def initialize
			
		end
	end

	class Encoder
		attr_accessor :angle
   
		def initialize(max)
			@max = max
			@angle = 0
		end

	end

	class Actuator
		attr_accessor :load, :angle
		def initialize
			@load = 0
			@angle = 0
		end
	end
end

Rover.instance
