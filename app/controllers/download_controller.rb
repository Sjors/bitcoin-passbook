class DownloadController < ApplicationController 
  load_and_authorize_resource
  def fetch_address
    @address = Address.where(download_code: params[:download_code]).where("download_code_expires_at > ?", Time.now).first
    
    unless @address.present?
      flash[:error] = "Invalid or expired download code #{ params[:download_code] }"
      redirect_to root_path
      return
    end
    
    reset_session
    session[:used_download_code] = true
    session[:address_secret] = @address.session_secret
    
    redirect_to download_pass_address_path(@address)
  end
end
