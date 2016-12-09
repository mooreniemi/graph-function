module Graph
  module Function
    module PlotConfig
      def set_up(plot)
        plot.ylabel ylabel
        plot.xlabel 'input size'
        plot.terminal (t = Graph::Function.configuration.terminal)
        plot.output Graph::Function.configuration.output unless t == 'x11'
      end

      private
      def ylabel
        if Graph::Function.configuration.memory
          Graph::Function.configuration.trials == 1 ? 'total allocation memsize (bytes)' : 'average total allocation memsize (bytes)'
        else
          Graph::Function.configuration.trials == 1 ? 'execution time (seconds)' : 'average execution time (seconds)'
        end
      end
    end
  end
end
