class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.belongs_to :menu
      t.string :chatwork_id
      t.string :message_id
      t.string :note
      t.string :name
      t.timestamps
    end
  end
end
