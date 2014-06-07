class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscripter_id
      t.integer :subscriptee_id

      t.timestamps
    end
  end
end
