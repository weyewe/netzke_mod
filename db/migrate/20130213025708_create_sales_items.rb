class CreateSalesItems < ActiveRecord::Migration
  def change
    create_table :sales_items do |t|
      t.integer :sales_order_id 
      t.string :code
      
      t.string :name
      t.text :description 
      
      t.date :expected_deadline 
      
      t.boolean :is_confirmed, :default => false
      t.boolean :is_deleted , :default => false  
      

      t.timestamps
    end
  end
end
