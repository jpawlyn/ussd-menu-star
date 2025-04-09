module SessionStore
  def set_cache_key_for_session(service_code, msisdn, session_id)
    RequestStore.store[:cache_key] = "#{service_code.country_code}/#{msisdn}/#{session_id}"
  end

  def create_session(menu_item, msisdn)
    store_session(current_menu_item_id: menu_item.id, msisdn:)
  end

  def fetch_session
    Rails.cache.read(RequestStore.store[:cache_key])
  end

  def store_session(value)
    Rails.cache.write(RequestStore.store[:cache_key], value, expires_in: 3.minutes)
  end

  def fetch_current_menu_item
    current_menu_item_id = fetch_session&.dig(:current_menu_item_id)
    return unless current_menu_item_id

    @fetch_current_menu ||= MenuItem.find(fetch_session&.dig(:current_menu_item_id))
  end

  def store_current_menu_item(menu_item)
    return unless menu_item

    current_cache = fetch_session
    current_cache[:current_menu_item_id] = menu_item.id
    store_session(current_cache)
  end

  def fetch_user_input_keys(menu_item)
    fetch_session.dig(:user_input, menu_item.id)&.keys || []
  end

  def store_user_input(menu_item, user_input, input)
    current_cache = fetch_session
    current_cache[:user_input] ||= {}
    current_cache[:user_input][menu_item.id] ||= {}
    current_cache[:user_input][menu_item.id][user_input.key] = input
    store_session(current_cache)
  end

  def fetch_end_of_session
    RequestStore.store[:end_of_session] || false
  end

  def store_end_of_session(end_of_session)
    RequestStore.store[:end_of_session] = end_of_session
  end
end
