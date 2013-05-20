class WelcomeController < ApplicationController 
  load_and_authorize_resource
  def index
    @address = Address.new
  end
end