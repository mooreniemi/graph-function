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

            title = case methods.size
                    when 1
                      "#{methods[0].name}"
                    when 2
                      "#{methods[0].name} vs #{methods[1].name}"
                    else
                      "#{methods.map {|m| camel_title(m.name) }.join(', ') }"
                    end
            plot.title title
            set_up(plot)

            x = Graph::Function.configuration.step
            pb = ProgressBar.create(title: title, total: x.size)

            methods.each do |m|
              pb.reset
              y = x.collect do |v|
                pb.increment
                data = data_generator.call(v)
                Benchmark.measure { m.call(data) }.real
              end

              plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
                ds.with = "linespoints"
                ds.title = "#{escape_underscores(m.name)}"
              end
            end
          end
        end
      end
    end
  end
end
