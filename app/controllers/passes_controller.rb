class PassesController < ApplicationController
  protect_from_forgery :except => :find_or_create
  skip_before_filter :verify_authenticity_token, :only => [:create]
    
  # GET
  def find_or_create
    # begin
      respond_to do |format|
        format.pkpass {
          pass ||=Passbook.pass_type_id_to_class(params[:pass_type_id]).find_or_create(params)
          render :pkpass => pass, :content_type => "application/vnd.apple.pkpass"
        }
      end
      # send_file pass, :type => "application/vnd.apple.pkpass"
      #rescue    # 
    #   @address = Address.find(params[:address_id])
    #   flash[:error] = "Something went wrong while creating the pass. Please  <a href='mailto:sjors%40bitcoin-passbook.com?subject=Pass%20creation%20error%20for%20address%20#{ @address.id.to_s}'>contact us</a>."
    #   redirect_to download_pass_address_path(@address)
    # end
  end

end
