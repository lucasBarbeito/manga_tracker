class Book < ApplicationRecord
  belongs_to :series, optional: true
  belongs_to :collection, optional: true
end
