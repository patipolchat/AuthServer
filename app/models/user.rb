class User < ApplicationRecord

  has_secure_password

  validates :username, 
    presence: true,
    uniqueness: true

  validates :password_digest,
    presence: true

  validates :name,
    presence: true
  
  validates :password, length: { in: 5..20 }

  def as_json(options = {})
    super(options.merge(except: :password_digest))
  end
end
