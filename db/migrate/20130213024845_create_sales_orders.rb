class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.integer :customer_id 
      t.string :code 
      t.boolean :is_deleted, :default => false 
      t.boolean :is_confirmed, :default => false 

      t.timestamps
    end
  end
end
