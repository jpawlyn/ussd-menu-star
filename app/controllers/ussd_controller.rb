class UssdController < ActionController::API
  def callback
    logger.info(params)
    account = Account.joins(:service_code).find_by!(
      service_code: { short_name: params[:short_name]&.downcase, country_code: params[:country_code]&.upcase })

    ussd_session = UssdSession.new(account, ussd_params)
    render plain: ussd_session.response
  end

  private

  def ussd_params
    params.permit(:phoneNumber, :sessionId, :text).tap do |ussd_params|
      ussd_params.require(:phoneNumber)
      ussd_params.require(:sessionId)
    end
  end
end
