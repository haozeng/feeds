class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :subscriptee_id
      t.integer :item_id
      t.string :type

      t.timestamps
    end
  end
end
