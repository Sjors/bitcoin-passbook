class AddDownloadCodeToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :download_code, :integer
    add_column :addresses, :download_code_expires_at, :datetime
    
  end
end
