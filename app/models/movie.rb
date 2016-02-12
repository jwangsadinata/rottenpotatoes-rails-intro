class Movie < ActiveRecord::Base
    # create an instance of class methods (self can be used for disambiguation too)
    def self.all_ratings
        # convert into a Proc -> select and map
        Movie.select(:rating).map(&:rating).uniq
    end
end
