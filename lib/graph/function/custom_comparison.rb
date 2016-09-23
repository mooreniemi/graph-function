module Graph
  module Function
    class CustomComparison
      include ReformatString
      attr_accessor :data_generator
      def initialize(generator)
        @data_generator = generator
      end

      def of(method_one, method_two)
        fail unless method_one.is_a?(Method) && method_two.is_a?(Method)

        Gnuplot.open do |gp|
          Gnuplot::Plot.new(gp) do |plot|
            self.class.send(:define_method, :a, proc(&method_one))
            self.class.send(:define_method, :b, proc(&method_two))

            plot.title  "#{camel_title(method_one.name)} vs #{camel_title(method_two.name)}"
            plot.ylabel 'execution time'
            plot.xlabel 'input size'

            x = (0..10000).step(1000).to_a

            y = x.collect do |v|
              Benchmark.measure { a(data_generator.call(v)) }.real
            end

            plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
              ds.with = "linespoints"
              ds.title = "#{escape_underscores(method_one.name)}"
            end

            z = x.collect do |v|
              Benchmark.measure { b(data_generator.call(v)) }.real
            end

            plot.data << Gnuplot::DataSet.new( [x, z] ) do |ds|
              ds.with = "linespoints"
              ds.title = "#{escape_underscores(method_two.name)}"
            end
          end
        end
      end
    end
  end
end
