require 'spec_helper'

describe Address do
  describe "Precision" do
    let(:address) {FactoryGirl.create(:address)}
    it "Can handle 1 satoshi" do
      address.update balance: BigDecimal.new("0.00000001")
      Address.where(base58: address.base58).first.balance.should eq(BigDecimal.new("0.00000001"))
    end
    
    it "Can't handle less than 1 satoshi" do
      address.update balance: BigDecimal.new("0.000000004")
      Address.where(base58: address.base58).first.balance.should eq(BigDecimal.new("0.00000000"))
    end
    
    it "Can handle all 21 million bitcoins, should someone aquire them" do
      address.update balance: BigDecimal.new("21000000")
      Address.where(base58: address.base58).first.balance.should eq(BigDecimal.new("21000000"))
    end
  end
  
  describe "Validates" do
    let(:address) {FactoryGirl.build(:address)}
    it "address can exist" do
      address.should be_valid
    end
    it "weird address cannot exist" do
      address.base58 = "ab"
      address.should_not be_valid
    end
  end
end