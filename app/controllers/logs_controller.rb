class LogsController < ApplicationController
  # Does not use CanCan
  skip_before_filter :verify_authenticity_token, :only => [:log]

  def log
    # if request && request.body
    #   request.body.rewind
    #   json_body = JSON.parse(request.body.read)
    #   File.open(File.expand_path(Rails.root) + "/log/devices.log", "a") do |f|
    #     f.write "[#{Time.now}] #{json_body["description"]}\n"
    #   end
    # end
      render :nothing => true, :status => 200
  end

end