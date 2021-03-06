class SalesOrderGrid < Netzke::Basepack::Grid
  
  # how can we not show the add, delete?
  # read only ? in the Netzke::Basepack::Grid
  # only allow add in form? How?
  js_configure do |c|
 
    # c.init_component = <<-JS
    #  
    #    function(){
    #      // calling superclass's initComponent
    #      this.callParent();
    #      this.addEvents('salesorderdelete');
    #      
    #      // Process selectionchange event to enable/disable actions
    #      this.getSelectionModel().on('selectionchange', function(selModel){
    #        if (this.actions.confirm) this.actions.confirm.setDisabled(!selModel.hasSelection());
    #      }, this);
    #    }
    #  JS
    
    c.mixin
  end
  
   
  
  
  action :confirm do |c|
    c.icon = :door_in
    c.disabled = true 
  end
  
  
  
  def configure(c)
    super
    c.model = "SalesOrder"
    c.enable_extended_search = false 
    c.enable_context_menu = false 
    c.enable_rows_reordering = false  
    c.scope = lambda do |x|
      x.where{ is_deleted.eq false }
    end
    c.bbar = [:add_in_form, :edit_in_form, :del, :confirm]
    c.read_only = true 
    c.columns = [
      {
        name:  :code,
        flex: 1 
      },
      {
        name: :customer__name, 
        flex: 1 
      }, 
      { :name => :status,
        :width => 150,
        :header => "Status",
        :tooltip => "Recently updated",
        :getter => lambda { |r|
          bulb = r.is_confirmed ? "CONFIRMED" : "PENDING"
          "<div>#{bulb}</div>"
        }
      }
    ]
  end
  
  def preconfigure_record_window(c)
    super
    c.form_config.klass = SalesOrderForm
    c.width = 600
  end
  
  
  
  endpoint :can_be_confirmed do |params, this|
    # how can we send result? 
    puts "We are in the endpoint\n"*100
    
    sales_order = SalesOrder.find_by_id params[:record_id]
    
  
    sales_order.confirm
   
    
    if sales_order.errors.size != 0 
      sales_order.errors.to_a.each do |msg|
        flash :error => msg
      end
      
      this.netzke_feedback @flash
    end
  end
   
  #  our own taste of data deletion 
  endpoint :delete_data do |params, this|
    if !config[:prohibit_delete]
      record_ids = ActiveSupport::JSON.decode(params[:records])
      success = true
      record_ids.each {|id|
        record = data_adapter.find_record(id)
        
        
        
        record.delete_or_destroy
        
        
        if ( record.is_confirmed? and not record.is_deleted? )  or 
           ( not record.is_confirmed? and record.persisted? ) # if it is not confirmed, and still exists after delete
          success = false
          record.errors.to_a.each do |msg|
            flash :error => msg
          end
        end
      }
      on_data_changed
      if success
        this.netzke_feedback I18n.t('netzke.basepack.grid.deleted_n_records', :n => record_ids.size)
        this.load_store_data get_data
        this.refresh_child_data
      else
        this.netzke_feedback @flash
      end
    else
      this.netzke_feedback I18n.t('netzke.basepack.grid.cannot_delete')
    end
  end
  
   

  include PgGridTweaks # the mixin , defining sorter 
end
