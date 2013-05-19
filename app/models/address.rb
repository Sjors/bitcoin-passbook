class Address < ActiveRecord::Base
  require "bitcoin"
  
  validates_presence_of :name
  validate :proper_bitcoin_address
  
  has_one :pass
  has_many :transactions
  
  after_commit :touch_pass
  
  def push_update_to_clients!
    return false unless self.pass
    
    self.pass.registrations.each do |registration|
      unless registration.registered_with_urban_airship
        res = Urbanairship.register_device(registration.push_token, :alias => "address-" + self.id.to_s)
        registration.update registered_with_urban_airship: true if res == {}
      end
      
      notification = {:schedule_for => [Time.now],:device_tokens => [registration.push_token], :aps => {}}
      Urbanairship.push(notification)
    end
  end
  
  private
  def proper_bitcoin_address
    unless Bitcoin::valid_address?(self.base58)
      errors.add(:base58, "is not a properly formatted bitcoin address")
    end
  end
  
  def touch_pass
    self.pass.touch
  end
  
end
