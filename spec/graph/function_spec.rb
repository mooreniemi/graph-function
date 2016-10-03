require 'spec_helper'

describe Graph::Function do
  it 'has a version number' do
    expect(Graph::Function::VERSION).not_to be nil
  end

  describe Graph::Function::IntsComparison do
    def one(array)
      array.each {|e| e }
    end
    def two(array)
      array.each {|e| e * 2 }
    end
    it 'plots two functions' do
      Graph::Function::IntsComparison.of(method(:one), method(:two))
    end
    it 'can output to gif' do
      Graph::Function.configuration.terminal = 'gif'
      Graph::Function.configuration.output = File.expand_path('../two_func.gif', __FILE__)
      Graph::Function::IntsComparison.of(method(:one), method(:two))
    end
    it 'can output to txt' do
      Graph::Function.configuration.terminal = 'dumb'
      Graph::Function.configuration.output = File.expand_path('../two_func.txt', __FILE__)
      Graph::Function::IntsComparison.of(method(:one), method(:two))
    end
  end

  describe Graph::Function::Comparison do
    let(:rantly_generator) do
      proc {|size|
        Rantly { dict(size) { [string, integer] }}
      }
    end
    let(:hash_first_proc) { proc {|hash| hash.values.first}}
    def hash_last_value(hash)
      hash.values.last
    end
    def hash_first_value(hash)
      hash.values.first
    end
    it 'uses a Rantly generator for x data' do
      Graph::Function.configuration.terminal = 'gif'
      Graph::Function.configuration.output = File.expand_path('../comparison.gif', __FILE__)
      comparison = Graph::Function::Comparison.new(rantly_generator)
      comparison.of(method(:hash_last_value), method(:hash_first_value))
    end
    it 'can take a proc as input' do
      Graph::Function.configuration.terminal = 'gif'
      Graph::Function.configuration.output = File.expand_path('../proc_v_method.gif', __FILE__)
      comparison = Graph::Function::Comparison.new(rantly_generator)
      comparison.of(hash_first_proc, method(:hash_first_value))
    end
    it 'can perform multiple trials' do
      Graph::Function.configuration.terminal = 'gif'
      Graph::Function.configuration.output = File.expand_path('../multitrial.gif', __FILE__)
      Graph::Function.configuration.trials = 3
      comparison = Graph::Function::Comparison.new(rantly_generator)
      comparison.of(method(:hash_last_value), method(:hash_first_value))
    end
  end

  describe "Comparison of one function" do
    let(:rantly_generator) do
      proc {|size|
        Rantly { array(size) {string} }
      }
    end
    def single_func(as)
      as.map(&:upcase)
    end
    let(:faker_generator) do
      proc {|size|
        Rantly(size) { call(Proc.new { Faker::Date.backward(14) }) }
      }
    end
    def custom_types(faked)
      if faked.is_a?(Array)
        faked.map {|e| e.strftime("at %I:%M%p") }
      else
        faked.strftime("at %I:%M%p")
      end
    end
    it 'uses a Rantly generator and acts on one function' do
      Graph::Function.configuration.terminal = 'gif'
      Graph::Function.configuration.output = File.expand_path('../rantly.gif', __FILE__)
      graph = Graph::Function::Comparison.new(rantly_generator)
      graph.of(method(:single_func))
    end
    it 'can use a Faker/Rantly generator and acts on one function' do
      Graph::Function.configuration.terminal = 'gif'
      Graph::Function.configuration.output = File.expand_path('../faker.gif', __FILE__)
      graph = Graph::Function::Comparison.new(faker_generator)
      graph.of(method(:custom_types))
    end
  end

  describe Graph::Function::ReformatString do
    include Graph::Function::ReformatString

    it 'extracts a filename and line number from Proc#to_s' do
      proc_to_s = '#<proc:07ffb5380c220@/users/corajr/development/graph-function/spec/graph/function_spec.rb:36>'
      expect(extract_filename(proc_to_s)).to eq('function_spec.rb:36')
    end
  end
end
