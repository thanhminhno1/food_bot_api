class Order < ApplicationRecord
  has_many :food_orders, dependent: :destroy
  has_many :foods, through: :food_orders
  belongs_to :menu

  scope :today, ->{where created_at: Date.today.beginning_of_day..Date.today.end_of_day}
end
