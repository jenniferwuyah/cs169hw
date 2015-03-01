class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :director, :description, :release_date

  def self.all_ratings
    ['G','PG','PG-13','R','NC-17']
  end

end
