module Graph
  module Function
    class Comparison
      include ReformatString
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

            plot.title  "#{methods.map {|m| camel_title(m.name) }.join(', ') }"
            plot.ylabel 'execution time'
            plot.xlabel 'input size'

            x = (0..10000).step(1000).to_a

            methods.each do |m|
              y = x.collect do |v|
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
