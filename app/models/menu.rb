class Menu < ApplicationRecord
  has_many :foods, dependent: :destroy
  has_many :orders, dependent: :destroy

  scope :today, ->{where created_at: Date.today.beginning_of_day..Date.today.end_of_day}
end
