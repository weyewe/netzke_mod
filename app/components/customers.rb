class Customers < Netzke::Basepack::Grid
  
  # how can we not show the add, delete?
  # read only ? in the Netzke::Basepack::Grid
  # only allow add in form? How?
  
  
  def configure(c)
    super
    c.model = "Customer"
    c.enable_extended_search = false 
    c.enable_context_menu = false 
    c.enable_rows_reordering = false  
    c.scope = lambda do |x|
      x.where{ is_deleted.eq false }
    end
    c.bbar = [:add_in_form, :edit_in_form, :del]
    c.read_only = true 
    c.columns = [
      {
        name:  :name,
        flex: 1 
      },
      {
        name: :address, 
        flex: 1 
      },
      {
        name: :other_info, 
        flex: 1
      },
      {
        name: :contact_person,
        flex: 1 
      },
      {
        name: :phone, 
        flex: 1 
      }# ,
      #       :is_deleted
      # { :name => :status,
      #   :width => 50,
      #   :header => "Status",
      #   :tooltip => "Recently updated",
      #   :getter => lambda { |r|
      #     bulb = r.is_deleted ? "OFF" : "ON"
      #     "<div>#{bulb}</div>"
      #   }
      # }
    ]
  end
  
  def preconfigure_record_window(c)
    super
    c.form_config.klass = CustomerForm
    c.width = 600
  end
   
  #  our own taste of data deletion 
  endpoint :delete_data do |params, this|
    if !config[:prohibit_delete]
      record_ids = ActiveSupport::JSON.decode(params[:records])
      success = true
      record_ids.each {|id|
        record = data_adapter.find_record(id)
        record.set_as_deleted
        if !record.is_deleted
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
      else
        this.netzke_feedback @flash
      end
    else
      this.netzke_feedback I18n.t('netzke.basepack.grid.cannot_delete')
    end
  end
  
   

  include PgGridTweaks # the mixin , defining sorter 
end
