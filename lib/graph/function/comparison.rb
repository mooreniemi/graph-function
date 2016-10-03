module Graph
  module Function
    class Comparison
      include ReformatString
      include PlotConfig
      attr_accessor :data_generator

      def initialize(generator)
        @data_generator = generator
      end

      def of(*functions)
        fail unless functions.all? {|f| f.respond_to?(:call) }

        Gnuplot.open do |gp|
          Gnuplot::Plot.new(gp) do |plot|

            title = functions_to_title(functions)
            plot.title title
            set_up(plot)

            x = Graph::Function.configuration.step
            trials = Graph::Function.configuration.trials
            pb = ProgressBar.create(title: title, total: x.size)

            functions.each do |f|
              pb.reset
              y = x.collect do |v|
                pb.increment
                data = data_generator.call(v)
                (1..trials).collect do |_|
                  Benchmark.measure { f.call(data) }.real
                end.reduce(0.0, :+) / trials
              end

              plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
                ds.with = "linespoints"
                ds.title = "#{escape_underscores(fname(f))}"
              end
            end
          end
        end
      end

      private
      def fname(function)
        function.respond_to?(:name) ? function.name : extract_filename(function.to_s)
      end

      def functions_to_title(functions)
        case functions.size
        when 1
          "#{camel_title(fname(functions[0]))}"
        when 2
          "#{camel_title(fname(functions[0]))} vs #{camel_title(fname(functions[1]))}"
        else
          "#{functions.map {|f| camel_title(fname(f)) }.join(', ') }"
        end
      end
    end
  end
end
