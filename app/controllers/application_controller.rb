class ApplicationController < ActionController::Base
  # rescue_from LoginFailed, with: :login_failed
  before_action :detect_mobile_variant

  def login_failed
    render template: "shared/login_failed", status: 401
  end

  def detect_mobile_variant
    request.variant = :mobile if request.user_agent =~ /iphone/
  end  
end
