class Food < ApplicationRecord
  has_many :food_orders
  has_many :orders, through: :food_orders
  belongs_to :menu
  
  validates :name, presence: true
end
