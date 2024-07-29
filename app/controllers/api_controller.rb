class ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Pagy::Backend

  respond_to :json
  before_action :authenticate

  unless Rails.env.production?
    around_action :n_plus_one_detection

    def n_plus_one_detection
      Prosopite.scan
      yield
    ensure
      Prosopite.finish
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      user = User.find_by(api_key: token)

      if user.present? && ActiveSupport::SecurityUtils.secure_compare(token, user.api_key)
        @current_user = user
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
