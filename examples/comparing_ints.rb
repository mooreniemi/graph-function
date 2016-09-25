require 'graph/function'

Graph::Function.as_gif(File.expand_path('../comparing_ints.gif', __FILE__))

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

Graph::Function::IntsComparison.of(method(:sort), method(:bubble_sort))
