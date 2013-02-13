class Customer < ActiveRecord::Base
  # attr_accessible :title, :body
  validates_presence_of :other_info
  validates_presence_of :name 
  
  has_many :sales_orders
  
  def set_as_deleted
    self.is_deleted = true 
    self.save
  end
end
