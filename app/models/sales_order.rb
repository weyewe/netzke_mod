class SalesOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :customer 
  has_many :sales_items 
  validates_presence_of :customer_id
  
  validate :customer_must_not_be_deleted
  
  def customer_must_not_be_deleted
    customer = Customer.find_by_id self.customer_id
    
    if customer.nil? or customer.is_deleted? 
      errors.add(:customer_id , "harus diisi" )  
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
