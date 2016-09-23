require 'spec_helper'

describe Graph::Function do
  it 'has a version number' do
    expect(Graph::Function::VERSION).not_to be nil
  end

  describe Graph::Function::Comparison do
    def one(array)
      array.each {|e| puts e }
    end
    def two(array)
      array.each {|e| puts e * 2 }
    end
    it 'plots two functions' do
      Graph::Function::Comparison.of(method(:one), method(:two))
    end
  end

  describe Graph::Function::CustomComparison do
    let(:rantly_generator) do
      proc {|size|
        Rantly { dict(size) { [string, integer] }}
      }
    end
    def hash_last_value(hash)
      hash.values.last
    end
    def hash_first_value(hash)
      hash.values.first
    end
    it 'uses a Rantly generator for x data' do
      comparison = Graph::Function::CustomComparison.new(rantly_generator)
      comparison.of(method(:hash_last_value), method(:hash_first_value))
    end
  end

  describe Graph::Function::Only do
    let(:rantly_generator) do
      proc {|size|
        Rantly { array(size) {string} }
      }
    end
    def single_func(as)
      as.map(&:upcase)
    end
    it 'uses a Rantly generator and acts on one function' do
      graph = Graph::Function::Only.new(rantly_generator)
      graph.of(method(:single_func))
    end
  end
end
