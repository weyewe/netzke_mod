class SalesOrdersSalesItems < Netzke::Base
  # Remember regions collapse state and size
  include Netzke::Basepack::ItemPersistence

  def configure(c)
    super
    c.items = [
      { netzke_component: :sales_orders, region: :north, flex: 1 },
      { netzke_component: :sales_items , region: :center    } 
    ]
  end

  js_configure do |c|
    c.layout = :border
    c.border = false

    # Overriding initComponent
    c.init_component = <<-JS
      function(){
        // calling superclass's initComponent
        this.callParent();

        // setting the 'rowclick' event
        var view = this.getComponent('sales_orders').getView();
        view.on('itemclick', function(view, record){
          // The beauty of using Ext.Direct: calling 3 endpoints in a row, which results in a single call to the server!
          this.selectSalesOrder({sales_order_id: record.get('id')});
          this.getComponent("sales_items").setTitle( "SalesItems dari Sales Order: " + record.get("code"));
          this.getComponent('sales_items').getStore().load(); 
        }, this);
      }
    JS
  end

  endpoint :select_sales_order do |params, this|
    # store selected boss id in the session for this component's instance
    component_session[:selected_sales_order_id] = params[:sales_order_id]
  end

  component :sales_orders do |c|
    c.klass = SalesOrderGrid
  end

  component :sales_items do |c|
    sales_order = SalesOrder.find_by_id component_session[:selected_sales_order_id] 
    c.klass = SalesItemGrid
    c.data_store = {auto_load: false}
    # c.scope = {:sales_order_id => component_session[:selected_sales_order_id]}
    # c.header = "Sales Order code: #{sales_order.code}"
     
      
    c.scope = lambda do |x|
      x.where( :is_deleted => false ,
      :sales_order_id =>component_session[:selected_sales_order_id]  )  
    end
    c.strong_default_attrs = {:sales_order_id => component_session[:selected_sales_order_id]}
  end
 
end
