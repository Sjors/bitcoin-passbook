class AddSessionSecretToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :session_secret, :string
  end
end
