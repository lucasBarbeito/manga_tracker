class Collection < ApplicationRecord
  has_many :books
  has_many :series, through: :books
end
