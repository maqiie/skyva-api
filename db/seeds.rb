# db/seeds.rb
require 'faker'

# Create random categories
5.times do
  Category.create(
    name: Faker::Commerce.department(max: 1, fixed_amount: true),
    description: Faker::Lorem.sentence
  )
end

# Create specific categories
Category.create(name: 'Clothes', description: 'Clothing category')
Category.create(name: 'Shoes', description: 'Footwear category')
Category.create(name: 'Jewelry', description: 'Jewelry category')

puts 'Seed data has been created.'
