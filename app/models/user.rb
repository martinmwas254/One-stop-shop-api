class User < ApplicationRecord
    has_many :orders, dependent: :destroy
    has_one :cart, dependent: :destroy
    has_many :products, dependent: :destroy
    has_secure_password
  
    validates :name, presence: true
    validates :password, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
   
  end