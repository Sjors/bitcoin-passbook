class Address < ActiveRecord::Base
  require "bitcoin"
  
  validates_presence_of :name
  validate :proper_bitcoin_address
  
  has_one :pass
  has_many :transactions
  
  private
  def proper_bitcoin_address
    unless Bitcoin::valid_address?(self.base58)
      errors.add(:base58, "is not a properly formatted bitcoin address")
    end
  end
  
end
