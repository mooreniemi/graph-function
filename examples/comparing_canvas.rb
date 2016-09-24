require 'graph/function'

file = File.expand_path('../comparing.html', __FILE__)
Graph::Function.configure do |config|
	config.terminal = 'canvas'
	config.output = file
end

def bubble_sort(array)
	n = array.length
	loop do
		swapped = false
		(n-1).times do |i|
			if array[i] > array[i+1]
				array[i], array[i+1] = array[i+1], array[i]
				swapped = true
			end
		end
		break if not swapped
	end
	array
end

def sort(array)
	array.sort
end

puts "output: #{file}"
Graph::Function::IntsComparison.of(method(:sort), method(:bubble_sort))
