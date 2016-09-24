module Graph
  module Function
    class IntsComparison
      extend ReformatString
      extend PlotConfig

      def self.of(method_one, method_two)
        fail unless method_one.is_a?(Method) && method_two.is_a?(Method)

        Gnuplot.open do |gp|
          Gnuplot::Plot.new(gp) do |plot|
            self.class.send(:define_method, :a, proc(&method_one))
            self.class.send(:define_method, :b, proc(&method_two))

            plot.title  "#{camel_title(method_one.name)} vs #{camel_title(method_two.name)}"
            set_up(plot)

            x = (0..10000).step(1000).to_a

            pb = ProgressBar.create
            y = x.collect do |v|
              pb.increment
              array = (0..v - 1).to_a.shuffle
              Benchmark.measure { a(array) }.real
            end

            plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
              ds.with = "linespoints"
              ds.title = "#{escape_underscores(method_one.name)}"
            end

            pb = ProgressBar.create
            z = x.collect do |v|
              pb.increment
              array = (0..v - 1).to_a.shuffle
              Benchmark.measure { b(array) }.real
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
