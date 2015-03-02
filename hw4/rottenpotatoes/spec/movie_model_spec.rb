require 'spec_helper'

describe Movie do

  describe 'find movies with same director' do
    it 'should call Movie with director' do
      Movie.should_receive(:find_by_director).with('Star Wars')
      Movie.find_by_director('Star Wars')
    end
  end
end
  
