class WelcomeController < ApplicationController 
  def index
    @address = Address.new
  end
end