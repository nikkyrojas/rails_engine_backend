class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  # validates_presence_of :merchant
  belongs_to :merchant
end