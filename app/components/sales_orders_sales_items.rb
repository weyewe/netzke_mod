class SalesOrdersSalesItems < Netzke::Base
  # Remember regions collapse state and size
  include Netzke::Basepack::ItemPersistence

# clone this guy
# http://doug.everly.org/category/webdev/


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
        
        
        
        console.log("callParent");
        this.callParent();
        
        console.log("setup relayEvents")
        var view = this.getComponent('sales_orders').getView();
        // this.relayEvents(view, ['salesorderdelete']);

        // setting the 'rowclick' event
        
        console.log("respond to itemclick");
        view.on('itemclick', function(view, record){
          // The beauty of using Ext.Direct: calling 3 endpoints in a row, which results in a single call to the server!
          this.selectSalesOrder({sales_order_id: record.get('id')});
          this.getComponent("sales_items").setTitle( "SalesItems dari Sales Order: " + record.get("code"));
          this.getComponent('sales_items').getStore().load(); 
        }, this);
      
      
        console.log("respond to custom events");
        
        view.on("salesorderdelete", function(){ console.log("awesome callback"); }, this);
        
        
       // this.on({
       //   'salesorderdelete': function(x, obj){
       //     console.log("in the sales order delete @sales_orders_sales_items");
       //   }
       // });
        
        console.log("done initComponent");
        
        
        
    
        
        // var sales_items_view = this.getComponent('sales_items').getView();
        // this.relayEvents(view, ['sales_order_delete']);
        
        this.on("sales_order_delete", function(){
          console.log("sales_orders_sales_items receive relayEvents ");
        });
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
