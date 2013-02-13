class ClerkForm < Netzke::Basepack::PagingForm
  def configure(c)
    c.title = "Clerk Paging Form With Custom Layout And File Upload"
    c.model = "Clerk"

    boss_contact = [
      {:field_label => "First name", :name => :boss__first_name, :read_only => true},
      {:field_label => "Last name", :name => :boss__last_name, :read_only => true},
      {:field_label => "Email", :name => :boss__email, :read_only => true}
    ]

    boss_details = [
      {:field_label => "Salary", :name => :boss__salary, :read_only => true},
      {:field_label => "Amount of clerks", :name => :boss__clerks_number, :read_only => true}
    ]

    c.file_upload = true
    c.items = [
      {
        :layout => :hbox, :border => false,
        :items => [
          {:flex => 1, :border => false, :defaults => {:anchor => "-8"}, :items => [
            :first_name,
            :email,
            {:name => :image_link, :xtype => :displayfield, :display_only => true, :getter => lambda {|r| %Q(<a href='#{r.image.url}'>Download</a>) if r.image.url}},
            {:name => :image, :field_label => "Upload image", :xtype => :fileuploadfield, :getter => lambda {|r| ""}, :display_only => true}
          ]},
          
          # by doing boss__name, it is giving options boss.name => Because it contains the Boss.find_by_name?
          # so, it is somekind of agreement? 
          {:flex => 1, :border => false, :defaults => {:anchor => "100%"}, :items => [
            :last_name,
            :salary,
            :boss__name
          ]}
        ]
      },
      {
        :xtype => :fieldset, :title => "Boss info",
        :items => [
          {
            :xtype => :tabpanel, :body_padding => 5, :plain => true, :active_tab => 0,
            :items => [
              {:title => "Contact", :items => boss_contact},
              {:title => "Details", :items => boss_details}
            ]
          }
        ]
      }
    ]

    super
  end
end
