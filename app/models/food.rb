class Food < ApplicationRecord
  validates :name, presence: true
  has_many :food_orders, dependent: :destroy
  has_many :orders, through: :food_orders
end
