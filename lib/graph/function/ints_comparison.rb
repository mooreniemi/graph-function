module Graph
  module Function
    class IntsComparison < Comparison
      def initialize
        @data_generator = Proc.new {|v| (0..v - 1).to_a.shuffle }
      end

      def self.of(*methods)
        comparison = self.new
        comparison.of(*methods)
      end
    end
  end
end
