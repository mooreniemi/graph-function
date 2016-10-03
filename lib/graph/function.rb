require 'gnuplot'
require 'benchmark'
require 'rantly'
require 'faker'
require 'ruby-progressbar'

require 'graph/function/version'
require 'graph/function/reformat_string'
require 'graph/function/plot_config'
require 'graph/function/comparison'
require 'graph/function/ints_comparison'

module Graph
  module Function
    # https://robots.thoughtbot.com/mygem-configure-block
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    singleton_class.send(:alias_method, :as_x11, :configure)

    def self.file_location(ext)
      File.new("#{$0.slice(0..-4)}.#{ext}", 'w').path
    end

    def self.as_gif(file = file_location('gif'))
      self.configure do |config|
        config.terminal = 'gif'
        config.output = file
      end
    end

    def self.as_canvas(file = file_location('html'))
      self.configure do |config|
        config.terminal = 'canvas'
        config.output = file
      end
    end

    class Configuration
      attr_accessor :terminal, :output
      attr_accessor :step
      attr_accessor :trials

      # defaults
      # see https://github.com/rdp/ruby_gnuplot/blob/master/examples/output_image_file.rb
      # or http://mibai.tec.u-ryukyu.ac.jp/~oshiro/Doc/gnuplot_primer/gptermcmp.html
      def initialize
        @terminal = 'x11'
        @output = '.'
        @step = (0..10_000).step(1000).to_a
        @trials = 1
      end
    end
  end
end
