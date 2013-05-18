class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.references :address
      t.string :serial_number     
      t.string :authentication_token

      t.timestamps
    end
    add_index :passes, :address_id
  end
end