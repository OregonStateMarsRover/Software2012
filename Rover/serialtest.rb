require 'rubygems'
require 'serialport'

def send(serial_port, target,data)
	startByte = 202.chr
	targetByte = target.chr
	lengthByte = data.length.chr

	data = "#{targetByte}#{lengthByte}#{data}"

	csum = checksum(data)
	data = startByte + data + csum.chr
	serial_port.write data
end

def read(serial_port)
	serial_port.read_timeout = 0

	startByte = serial_port.getc
	while startByte.to_i != 202 do
		print "throw ", startByte = serial_port.getc
		puts
	end
	targetByte = serial_port.getc.to_i
	lengthByte = serial_port.getc.to_i
	d = []
	lengthByte.times{
		d << serial_port.getc.chr
	}
	checkSumByte = serial_port.getc.to_i
	puts "[#{startByte}][#{targetByte}][#{lengthByte}]#{d}[#{checkSumByte}]"

	puts data = "#{targetByte.chr}#{lengthByte.chr}#{d}"

	puts csum = checksum(data)

	return d, (csum == checkSumByte)
end

def checksum(data)
	sum = 0
	data.chars{ |c|
		sum += c[0]
	}
	return 255 - (sum % 2**8)
end


def main
	SerialPort.open "/dev/ttyUSB0", 115200,8,1,SerialPort::NONE do |sp|
		#puts "Sending message"
		send(sp,2,"MABCDEFGHIJKL")


		data, check = read(sp)
		if check then
			print data
			puts
		else
			puts "checksum failed"
		end
	
	end

end

main