module Graph
  module Function
    module PlotConfig
      def set_up(plot)
        plot.ylabel (Graph::Function.configuration.trials == 1 ? 'execution time (seconds)' : 'average execution time (seconds)')
        plot.xlabel 'input size'
        plot.terminal (t = Graph::Function.configuration.terminal)
        plot.output Graph::Function.configuration.output unless t == 'x11'
      end
    end
  end
end
