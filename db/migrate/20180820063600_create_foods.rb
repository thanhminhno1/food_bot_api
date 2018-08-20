class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.belongs_to :menu
      t.string :name
      t.timestamps
    end
  end
end
