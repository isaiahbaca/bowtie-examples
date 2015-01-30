class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  before_action :verify_user_id

  def verify_user_id
    if current_user_id.nil?
      respond_to do |format|
        format.json { render json: { status: :error, message: t(:unauthorized) }, status: 403 }
        format.html { redirect_to "/users/sign_in" }
      end

      return false
    end
  end

  def current_user_id
    request.headers['HTTP_X_BOWTIE_USER_ID']
  end

  def render_json_error(message=nil, data=nil)
    render json: { status: :error, data: data, message: message || t(:failure_undescribed) }
  end

  def render_json_success(data=nil)
    render json: { status: :success, data: data }
  end
end
