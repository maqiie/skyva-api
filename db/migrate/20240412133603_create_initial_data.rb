# db/migrate/[timestamp]_create_initial_data.rb

class CreateInitialData < ActiveRecord::Migration[6.0]
  def change
    # Create specific categories
    Category.create(name: 'Clothes', description: 'Clothing category')
    Category.create(name: 'Shoes', description: 'Footwear category')
    Category.create(name: 'Jewelry', description: 'Jewelry category')
    Category.create(name: 'Cosmetics', description: 'cosmetics\'s category')
    Category.create(name: 'Women', description: 'Women\'s clothing')

    # Create random brands
    5.times do
      Brand.create(name: Faker::Company.name, description: Faker::Lorem.sentence)
    end
  end
end
