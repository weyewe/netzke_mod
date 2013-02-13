number_of_bosses = 50

Boss.delete_all
bosses_ids = []
number_of_bosses.times do
  first_name = Faker::Name.first_name
  email = "#{first_name.downcase}@#{Faker::Internet.email.split("@").last}"
  a_boss = Boss.create({
    :first_name => first_name,
    :last_name => Faker::Name.last_name,
    :email => email,
    :salary => (rand(10)+1)*10000
  })
  bosses_ids << a_boss.id
end


Clerk.delete_all
200.times do
  first_name = Faker::Name.first_name
  email = "#{first_name.downcase}@#{Faker::Internet.email.split("@").last}"
  Clerk.create({
    :boss_id => bosses_ids[rand(number_of_bosses)],
    :first_name => first_name,
    :last_name => Faker::Name.last_name,
    :email => email,
    :salary => (rand(10)+1)*1000,
    :subject_to_lay_off => rand > 0.8,
    :created_at => 15.minutes.ago,
    :updated_at => 15.minutes.ago
  })
end


customer_name_list = [
  "Astari Wiyono",
  "Bangka Jaya",
  "Cacing Hitam",
  "Cacing Putih", 
  "Tito Husein",
  "Edwin Surya",
  "Irfan Effendi",
  "Winda Yunnal", 
  "Hongky Wijaya",
  "Yongky Wijaya",
  "Yoga Satria"
]

count = 1
10.times.each do |x|
  Customer.create(
    :name => " #{customer_name_list[x]} ",
    :address => "#{x} Address",
    :other_info => " #{x}  other info",
    :contact_person => "#{x} contact person",
    :phone => "#{x} phone"
  )
end
