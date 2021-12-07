# frozen_string_literal: true

class Rating < ApplicationRecord
    belongs_to :user
    belongs_to :news_item
    
    #def new do |rating|
    # @rating = 
  
    def self.rate_scale
        [1, 2, 3, 4, 5]
    end
end
