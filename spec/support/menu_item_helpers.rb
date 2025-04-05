module MenuItemHelpers
  def within_menu_items_table(row:)
    within(:xpath, "//*[@id='has_many_field_show_menu_items']//tbody/tr[#{row}]") do
      yield
    end
  end

  def check_menu_item(row:)
    find(:xpath, "//*[@id='has_many_field_show_menu_items']//tbody/tr[#{row}]//input[@type='checkbox']").set(true)
  end

  def uncheck_menu_item(row:)
    find(:xpath, "//*[@id='has_many_field_show_menu_items']//tbody/tr[#{row}]//input[@type='checkbox']").set(false)
  end
end

RSpec.configure do |config|
  config.include MenuItemHelpers, type: :system
end
