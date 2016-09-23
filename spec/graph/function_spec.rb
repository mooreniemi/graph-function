require 'spec_helper'

describe Graph::Function do
  it 'has a version number' do
    expect(Graph::Function::VERSION).not_to be nil
  end

  describe '#compare' do
    def one(array)
      array.each {|e| puts e }
    end
    def two(array)
      array.each {|e| puts e * 2 }
    end
    it 'plots two functions' do
      comparison = Graph::Function::Comparison.new
      comparison.of(method(:one), method(:two))
    end
  end
end
