class JobPost < ApplicationRecord
    validates :title, presence: true
    validates :min_salary, numericality: {
        greater_than: 20_000
    }
end
