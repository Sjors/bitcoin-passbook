class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :address, index: true
      t.decimal :amount, :precision => 16, :scale => 8
      t.datetime :date

      t.timestamps
    end
  end
end
