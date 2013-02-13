class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :contact_person  
      t.string :address
      t.string :phone
      
      t.text :other_info
      
      t.boolean :is_deleted , :default => false

      t.timestamps
    end
  end
end
