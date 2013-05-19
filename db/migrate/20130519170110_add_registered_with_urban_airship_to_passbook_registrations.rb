class AddRegisteredWithUrbanAirshipToPassbookRegistrations < ActiveRecord::Migration
  def change
    add_column :passbook_registrations, :registered_with_urban_airship, :boolean, :default => false
  end
end
