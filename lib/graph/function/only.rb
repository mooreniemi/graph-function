module Graph
  module Function
    class Only
      include ReformatString
      attr_accessor :data_generator

      def initialize(generator)
        @data_generator = generator
      end

      def of(method_obj)
        fail unless method_obj.is_a?(Method)

        self.class.send(:define_method, :a, proc(&method_obj))

        Gnuplot.open do |gp|
          Gnuplot::Plot.new(gp) do |plot|

            plot.title  "#{camel_title(method_obj.name)}"
            plot.ylabel 'execution time'
            plot.xlabel 'input size'

            x = (0..10000).step(1000).to_a

            y = x.collect do |v|
              data = data_generator.call(v)
              Benchmark.measure { a(data) }.real
            end

            plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
              ds.with = "linespoints"
              ds.title = "#{escape_underscores(method_obj.name)}"
            end
          end
        end
      end
    end
  end
end
