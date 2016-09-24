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

        methods.each do |m|
          self.class.send(:define_method, m.name, proc(&m))
        end

        Gnuplot.open do |gp|
          Gnuplot::Plot.new(gp) do |plot|

            plot.title  "#{title = methods.map {|m| camel_title(m.name) }.join(', ') }"
						set_up(plot)

            x = (0..10000).step(1000).to_a
            pb = ProgressBar.create(title: title, total: x.size)

            methods.each do |m|
              pb.reset
              y = x.collect do |v|
                pb.increment
                data = data_generator.call(v)
                # FIXME can i get ride of the cost of `send`?
                Benchmark.measure { self.send(m.name, data) }.real
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
