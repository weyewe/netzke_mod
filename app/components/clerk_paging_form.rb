class ClerkPagingForm < Netzke::Basepack::PagingForm
  # paging form will show all fields in the record. no styling.. everything is out 
  def configure(c)
    super
    c.model = "Clerk"
  end
end
