class DynamicTabPanel < Netzke::Basepack::TabPanel
  component :clerks
  component :bosses
  component :bosses_and_clerks

  def configure(c)
    c.active_tab = 0
    c.prevent_header = true
    c.items = [ { :title => "I'm just a simple Ext.Panel" }, :clerks, :bosses, :bosses_and_clerks ]
    super
  end
end
