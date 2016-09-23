module Graph
  module Function
    module PlotConfig
      def set_up(plot)
        plot.ylabel 'execution time'
        plot.xlabel 'input size'
        plot.terminal (t = Graph::Function.configuration.terminal)
        plot.output Graph::Function.configuration.output unless t == 'x11'
      end
    end
  end
end
