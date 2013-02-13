class SalesItem < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sales_order
  validates_presence_of :sales_order_id
  validates_presence_of :code
  validates_presence_of :name
  
  validate :sales_order_must_be_active
  
  def sales_order_must_be_active
    sales_order = SalesOrder.find_by_id self.sales_order_id
    
    if sales_order.nil? or sales_order.is_deleted? 
      errors.add(:sales_order_id , "harus aktif" )  
    end
  end
  
  
  def delete_or_destroy
    if self.is_confirmed?
      self.is_deleted = true
      self.save
    else
      self.destroy 
    end
  end
end
