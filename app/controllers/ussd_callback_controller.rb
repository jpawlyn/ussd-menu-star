class UssdCallbackController < ActionController::API
  def create
    logger.info(params)
    account = Account.joins(:service_code)
      .find_by!(service_code: { short_name: params[:short_name], country_code: params[:country_code].upcase })

    render plain: "CON #{account.main_menu.content}"
  end
end
