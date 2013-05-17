class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :base58
      t.string :name
      t.decimal :balance, :precision => 16, :scale => 8

      t.timestamps
    end
  end
end
