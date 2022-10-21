# frozen_string_literal: true

class Item < ApplicationRecord
  validates :name, presence: true
  validates_presence_of :description
  validates_presence_of :unit_price
  # validates_presence_of :merchant

  belongs_to :merchant
  has_many :invoice_items # , dependent: :destroy
  has_many :invoices, through: :invoice_items # , dependent: :destroy

  def self.find_name(name)
    where('name ILIKE ?', "%#{name.downcase}%")
    # where("name ILIKE ?")
    # .order("LOWER(name)")
  end

  def self.find_min(min)
    where('unit_price >= ?', min)
      .order('name')
  end

  def self.find_max(max)
    where('unit_price <= ?', max)
      .order('name')
  end

  def self.find_min_max(min, max)
    where('unit_price <= ? AND unit_price >= ?', max, min)
      .order('name')
  end
end
