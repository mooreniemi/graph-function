module Graph
  module Function
    class Comparison
      include ReformatString
      include PlotConfig
      attr_accessor :data_generator

      def initialize(generator)
        @data_generator = generator
      end

      def of(*methods)
        fail unless methods.all? {|m| m.is_a?(Method) }

        Gnuplot.open do |gp|
          Gnuplot::Plot.new(gp) do |plot|

            title = methods_to_title(methods)
            plot.title title
            set_up(plot)

            x = Graph::Function.configuration.step
            trials = Graph::Function.configuration.trials
            pb = ProgressBar.create(title: title, total: x.size)

            methods.each do |m|
              pb.reset
              y = x.collect do |v|
                pb.increment
                data = data_generator.call(v)
                (1..trials).collect do |_|
                  Benchmark.measure { m.call(data) }.real
                end.reduce(0.0, :+) / trials
              end

              plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
                ds.with = "linespoints"
                ds.title = "#{escape_underscores(m.name)}"
              end
            end
          end
        end
      end

      private
      def methods_to_title(methods)
        case methods.size
        when 1
          "#{camel_title(methods[0].name)}"
        when 2
          "#{camel_title(methods[0].name)} vs #{camel_title(methods[1].name)}"
        else
          "#{methods.map {|m| camel_title(m.name) }.join(', ') }"
        end
      end
    end
  end
end
