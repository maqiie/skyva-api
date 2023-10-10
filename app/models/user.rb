# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  enum role: [:user, :admin] # Define roles as enum
  has_many :addresses
  has_one :current_cart, class_name: 'Cart', dependent: :destroy
  has_many :orders
  has_one :cart
  # belongs_to :current_cart, class_name: "Cart", optional: true



end
