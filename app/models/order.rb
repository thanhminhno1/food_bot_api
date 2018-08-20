class Order < ApplicationRecord
  has_many :food_orders, dependent: :destroy
  has_many :foods, through: :food_orders
end
