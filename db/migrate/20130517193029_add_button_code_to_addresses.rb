class AddButtonCodeToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :button_code, :string
    add_column :addresses, :order_id, :string
    add_column :addresses, :paid, :boolean, :default => false
  end
end
