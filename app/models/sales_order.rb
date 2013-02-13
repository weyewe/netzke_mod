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
      self.sales_items.each do |si|
        si.delete_or_destroy
      end
    else
      self.destroy 
    end
  end
  
  def recover
    if self.is_deleted?
      self.is_deleted = false 
      self.save
      self.sales_items.each do |si|
        si.is_deleted = false
        si.save 
      end
    end
  end
  
  def confirm
    if self.is_confirmed == true 
      errors.add(:is_confirmed , "Sudah konfirmasi" )  
      return self 
    end
    
    if self.sales_items.count == 0 
      errors.add(:sales_item , "Harus setidaknya ada 1 sales item" )  
      return self
    end
    
    self.is_confirmed = true
    self.save 
    
    self.sales_items.each do |si|
      si.is_confirmed = true
      si.save 
    end
  end
end
