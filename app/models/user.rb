# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  enum role: [:user, :admin] # Define roles as enum
  has_many :addresses
  # has_one :current_cart, class_name: 'Cart', dependent: :destroy
  has_one :current_cart, class_name: 'Cart', foreign_key: 'user_id'

  
  has_many :orders
  has_one :cart
  
  def grant_admin_privileges
    update(admin: true) unless admin?
  end

  attribute :admin, :boolean


end
