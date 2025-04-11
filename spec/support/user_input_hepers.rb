module UserInputHelpers
  def within_user_inputs_table(row:)
    within(:xpath, "//*[@id='has_many_field_show_user_inputs']//tbody/tr[#{row}]") do
      yield
    end
  end

  def check_user_input(row:)
    find(:xpath, "//*[@id='has_many_field_show_user_inputs']//tbody/tr[#{row}]//input[@type='checkbox']").set(true)
  end

  def uncheck_user_input(row:)
    find(:xpath, "//*[@id='has_many_field_show_user_inputs']//tbody/tr[#{row}]//input[@type='checkbox']").set(false)
  end
end

RSpec.configure do |config|
  config.include UserInputHelpers, type: :system
end
