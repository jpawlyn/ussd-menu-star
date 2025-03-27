class UssdSession
  include SessionStore
  attr_reader :account, :response, :end_of_session

  def initialize(account, ussd_params)
    @account = account
    @user_input = ussd_params[:text].chomp("#").split("*").last if ussd_params[:text]
    @msisdn = ussd_params[:phoneNumber]
    @session_id = ussd_params[:sessionId]
    set_cache_key_for_session(account.service_code, @msisdn, @session_id)
    @response = process_input
    @end_of_session = fetch_end_of_session
  end

  private

  def process_input
    if fetch_current_menu_item && @user_input.present?
      return render_previous_menu(fetch_current_menu_item) if @user_input == "0"

      menu_item = fetch_current_menu_item.select_menu_item(@user_input)
      # render main menu if menu item is not found
      menu_item ? render_menu(menu_item) : render_main_menu
    else
      render_main_menu
    end
  end

  def render_previous_menu(current_menu_item)
    previous_menu = current_menu_item.menu_item
    render_main_menu unless previous_menu

    render_menu(previous_menu)
  end

  def render_main_menu
    main_menu_item = account.main_menu_item
    create_session(main_menu_item, @msisdn)
    "CON " + main_menu_item.menu_text
  end

  def render_menu(menu_item)
    store_current_menu_item(menu_item)
    text = "CON " + menu_item.menu_text
    text += "\n\n0 Back" if menu_item.menu_item
    text
  end
end
