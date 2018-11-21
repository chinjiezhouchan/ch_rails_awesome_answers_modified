class JobPost < ApplicationRecord

    belongs_to :user
    
    validates :title, presence: true
    validates :min_salary, numericality: {
        greater_than: 20_000
    }

    def self.search(query)
        where("title LIKE ?", "#{query}%")
    end
end
