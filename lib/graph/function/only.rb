module Graph
  module Function
    class Only
      include ReformatString
      include PlotConfig
      attr_accessor :data_generator

      def initialize(generator)
        @data_generator = generator
      end

      def of(method_obj)
        fail unless method_obj.is_a?(Method)

        self.class.send(:define_method, :a, proc(&method_obj))

        Gnuplot.open do |gp|
          Gnuplot::Plot.new(gp) do |plot|

            plot.title  "#{title = camel_title(method_obj.name)}"
            set_up(plot)

            x = Graph::Function.configuration.step
            pb = ProgressBar.create(title: title, total: x.size)

            y = x.collect do |v|
              pb.increment
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
