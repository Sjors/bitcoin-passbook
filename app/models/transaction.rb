class Transaction < ActiveRecord::Base
  belongs_to :address
  
  default_scope :order => {:date => :asc}
  
  after_commit :touch_address_and_pass
  
  private
  
  def touch_address_and_pass
    self.address.touch
    self.address.pass.touch
  end
end
