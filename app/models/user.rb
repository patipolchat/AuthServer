class User < ApplicationRecord

  has_secure_password

  validates :username, 
    presence: true,
    uniqueness: true

  validates :password_digest,
    presence: true
  
  validates :password, length: { in: 6..20 }
end
