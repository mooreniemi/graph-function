module Graph
  module Function
    module ReformatString
      def escape_underscores(s)
        s.to_s.gsub("_", "\\_")
      end
      def camel_title(s)
        s.to_s.split('_').collect(&:capitalize).join
      end
    end
  end
end
