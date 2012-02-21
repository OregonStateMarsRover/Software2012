def calculate_angle(angle1, angle2)
	180 - (angle1 - angle2)
end
puts calculate_angle(ARGV[0].to_i,ARGV[1].to_i)