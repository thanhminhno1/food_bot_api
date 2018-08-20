class CreateFoodOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :food_orders do |t|
      t.belongs_to :food
      t.belongs_to :order
      t.timestamps
    end
    add_index :food_orders, %i[food_id order_id], unique: true, name: "food_order"
  end
end
