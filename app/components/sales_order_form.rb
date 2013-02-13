# Our custom IssueForm - it has a custom layout and pre-assigned model
class SalesOrderForm < Netzke::Basepack::Form
  def configure(c)
    c.model = 'SalesOrder'
    c.record_id = SalesOrder.first.try(:id) # default record
    super
    
    
    c.items = [
      :customer__name, 
      {:xtype => 'fieldset', :title => "Code", :checkboxToggle => true, :items => [
        :code 
      ]} 
    ] 
  end
  
  # override the create_or_update_records
  # for customer, let it as it is. 
  
  # try to override from sales order and sales item. we need to confirm and finalize
private 
  # def create_or_update_record(hsh)
  #   hsh.merge!(config[:strong_default_attrs]) if config[:strong_default_attrs]
  #   @record ||= data_adapter.find_record hsh.delete(data_class.primary_key.to_s) # only pick up the record specified in the params if it was not provided in the configuration
  #     #data_class.find(:first, :conditions => {data_class.primary_key => hsh.delete(data_class.primary_key)})
  #   success = true
  # 
  #   @record = data_class.new if @record.nil?
  # 
  #   Customer.
  #   hsh.each_pair do |k,v|
  #     # ok, maybe we extend this part of the form. The netzke_submit endpoint is good.
  #     # in the create_or_update_record, we decide whether it is 
  #     # CONFIRM or UPDATE_CONFIRM
  #     # FINALIZE or UPDATE_FINALIZE
  #     # WHAT IS hsh?
  #     # => hsh = ActiveSupport::JSON.decode(params[:data])
  #     data_adapter.set_record_value_for_attribute(@record, fields[k.to_sym].nil? ? {:name => k} : fields[k.to_sym], v, config.role || :default)
  #   end
  # 
  # 
  # 
  #   # did we have complete success?
  #   success && data_adapter.save_record(@record)
  # end
  
end
