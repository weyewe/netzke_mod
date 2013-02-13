class Bosses < Netzke::Basepack::Grid
  
  # how can we not show the add, delete?
  # read only ? in the Netzke::Basepack::Grid
  # only allow add in form? How?
  
  def configure(c)
    super
    c.model = "Boss"
  end

  include PgGridTweaks # the mixin , defining sorter 
end
