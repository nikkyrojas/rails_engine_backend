class Item < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :description
    validates_presence_of :unit_price
    validates_presence_of :merchant
    belongs_to :merchant

    def self.find_min(min)
        where('unit_price >= ?',  min)
        .order('name')
    end

    def self.find_max(max)
        where('unit_price <= ?',  max)
        .order('name')
    end

    def self.find_min_max(min,max)
        where('unit_price <= ? AND unit_price >= ?',  max, min)
        .order('name')
    end
end
