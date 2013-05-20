SATOSHI_PER_BITCOIN = BigDecimal.new("100000000") # (1 BTC = 100,000,000 Satoshi)
class Address < ActiveRecord::Base
  require "bitcoin"
  require 'open-uri'
  
  validates_presence_of :name
  validates :name, :length => { :maximum => 20 }
  validate :proper_bitcoin_address
  
  has_one :pass, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  
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
  
  def fetch_balance_and_last_transaction!

    url ="https://blockchain.info/address/#{ self.base58 }?format=json&limit=1"
    res = JSON.parse(open(url).read)
    
    new_balance = BigDecimal.new(res["final_balance"].to_s) / SATOSHI_PER_BITCOIN
        
    if self.balance != new_balance
      self.update balance: new_balance
    end

    if res["txs"].count > 0
      last_known_transaction = self.transactions.last
      if !last_known_transaction || last_known_transaction.bitcoin_hash != res["txs"][0]["hash"]
        tally = 0
        
        res["txs"][0]["inputs"].each do |input|
          if input["addr"] == self.base58
            tally = tally - BigDecimal.new(input["value"].to_s)
          end
        end
        
        res["txs"][0]["out"].each do |output|
          if output["addr"] == self.base58
            tally = tally + BigDecimal.new(output["value"].to_s)
          end
        end
        
        self.transactions.create(bitcoin_hash: res["txs"][0]["hash"], 
                               amount: tally / SATOSHI_PER_BITCOIN,
                                 date: Time.at(res["txs"][0]["time"]))
      end
    end
  end
  
  private
  def proper_bitcoin_address
    unless Bitcoin::valid_address?(self.base58)
      errors.add(:base58, "is not a properly formatted bitcoin address")
    end
  end
  
  def touch_pass
    if self.pass
      self.pass.touch
    end
  end
  
end
