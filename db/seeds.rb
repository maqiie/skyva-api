# db/seeds.rb
require 'faker'

# Create random categories

# Create specific categories
Category.create(name: 'Clothes', description: 'Clothing category')
Category.create(name: 'Shoes', description: 'Footwear category')
Category.create(name: 'Jewelry', description: 'Jewelry category')
Category.create(name: 'Men', description: 'Men\'s clothing')
Category.create(name: 'Women', description: 'Women\'s clothing')

# Create random brands
5.times do
  Brand.create(name: Faker::Company.name, description: Faker::Lorem.sentence)
end

puts 'Seed data has been created.'
