class PassesController < ApplicationController
  load_and_authorize_resource 
  protect_from_forgery :except => :create
  skip_before_filter :verify_authenticity_token, :only => [:create]
  
  # POST /passes.pkpass
  # GET (for debugging)

  def create
    pass ||=Passbook.pass_type_id_to_class(params[:pass_type_id]).find_or_create(params)
    render :pkpass => pass
  end

end
