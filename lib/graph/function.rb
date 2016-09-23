require 'graph/function/version'
require 'gnuplot'
require 'benchmark'

module Graph
  module Function
    class Comparison
      def of(method_one, method_two)
        fail unless method_one.is_a?(Method) && method_two.is_a?(Method)

        Gnuplot.open do |gp|
          Gnuplot::Plot.new(gp) do |plot|
            self.class.send(:define_method, :a, proc(&method_one))
            self.class.send(:define_method, :b, proc(&method_two))

            plot.title  "#{method_one.name} vs #{method_two.name}"
            plot.ylabel 'execution time'
            plot.xlabel 'input size'

            x = (0..10000).step(1000).to_a

            y = x.collect do |v|
              array = (0..v - 1).to_a.shuffle
              Benchmark.measure { a(array) }.real
            end

            plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
              ds.with = "linespoints"
              ds.title = "#{method_one.name}"
            end

            z = x.collect do |v|
              array = (0..v - 1).to_a.shuffle
              Benchmark.measure { b(array) }.real
            end

            plot.data << Gnuplot::DataSet.new( [x, z] ) do |ds|
              ds.with = "linespoints"
              ds.title = "#{method_two.name}"
            end
          end
        end
      end
    end
  end
end
