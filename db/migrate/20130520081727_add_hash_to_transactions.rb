class AddHashToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :bitcoin_hash, :string
  end
end
