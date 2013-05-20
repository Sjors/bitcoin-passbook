class Ability
  include CanCan::Ability

  def initialize(session)
    # Landing page
    can :index, Welcome

    # Address creation and initial pass download
    can [:new, :create], Address
    
    can [:show, :order_progress, :download_pass], Address do |address|
       session[:address_secret] != "" && address.session_secret == session[:address_secret]
    end
    
    can [:edit, :update], Address do |address|
      can_show = can :show, address
      can_show && !address.paid
    end
    
    can :find_or_create, Pass do |pass|
      session[:address_secret] != "" && pass.address.session_secret == session[:address_secret]
    end
    
    can [:fetch_address], Download # Security check is done in that method
    
    # Pass updates and log entries by the Passbook app don't use CanCan. Their
    # security depends on the secracy of the serial number and authentication
    # token. The passbook app also uses https (Heroku generic certificate).
  end
end
