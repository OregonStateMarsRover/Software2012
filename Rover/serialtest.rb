require 'rubygems'
require 'serialport'
sp = SerialPort.new "/dev/ttyS0", 9600
puts sp.read
sp.write "hello"
puts "hello world"