FactoryGirl.define do
  factory :address do |a|
    a.base58 "1KHxSzFpdm337XtBeyfbvbS9LZC1BfDu8K"
    a.balance BigDecimal.new("0.02")
    a.name "Purple Dunes"
  end
end