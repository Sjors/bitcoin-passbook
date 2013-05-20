namespace :pass_address do :env
  desc "Fetch the latest balance and transactions and push updated passes"
  task :update => :environment do
    
    if Rails.env == "development"
      Rails.logger = Logger.new(STDOUT)
    end
    
    # Find all addresses which have been paid for and have a pass which is 
    # registered with a push token.
    @addresses = Address.joins(:pass).joins(:pass => :registrations).where(paid: true).where("passbook_registrations.push_token IS NOT NULL").uniq
    
    Rails.logger.info "Checking the latest balance and transactions for #{ @addresses.count } addresses..."
    
    @tally = 0
    @addresses.each do |address|
      last_update = address.updated_at.dup
      address.fetch_balance_and_last_transaction!
      
      if address.updated_at > last_update
        address.push_update_to_clients! 
        @tally = @tally + 1
      end
      
      sleep(1) # Don't hammer Blockchain.info
    end
    
    Rails.logger.info "Push new transaction for #{ @tally } addresses..."
    
  end
end