describe 'Menu item admin actions' do
  let!(:account) { create(:account) }
  let(:user) { create(:user) }
  before do
    sign_in_as user
  end

  it 'creates a main menu item followed by a submenu item' do
    visit avo.resources_menu_items_path
    click_on 'Create new menu item'
    fill_in 'Title', with: 'Main menu'
    select account.name, from: 'Account'
    click_on 'Save'

    expect(page).to have_content 'Menu item was successfully created.'
    expect(page).to have_content 'Main menu'
    expect(page).to have_content account.name

    click_on 'Create new menu item'
    fill_in 'Title', with: 'Sub menu'
    click_on 'Save'

    expect(page).to have_content 'Menu item was successfully created.'
    expect(page).to have_content 'Sub menu'
  end

  it 'updates a menu item' do
    menu_item = create(:main_menu_item)
    visit avo.resources_menu_items_path
    find(:xpath, "//td[contains(text(), '#{menu_item.title}')]").click
    click_on "Edit"
    fill_in 'Title', with: 'New title'
    click_on 'Save'

    expect(page).to have_content 'Menu item was successfully updated.'
    expect(page).to have_content 'New title'
  end

  it 'changes the ordering of submenu items' do
    menu_item = create(:main_menu_item)
    account = menu_item.account
    sub_menu_item_1 = create(:sub_menu_item, menu_item:, account:)
    sub_menu_item_2 = create(:sub_menu_item, menu_item:, account:)

    visit avo.resources_menu_item_path(menu_item)
    within_menu_items_table(row: 1) { expect(page).to have_content sub_menu_item_1.title }
    within_menu_items_table(row: 2) { expect(page).to have_content sub_menu_item_2.title }
    click_on 'Actions'
    click_on 'Move menu item down'

    expect(page).to have_content 'No menu item selected'
    check_menu_item(row: 1)
    click_on 'Actions'
    click_on 'Move menu item down'

    expect(page).to have_content 'Successfully moved the menu item down one place'
    within_menu_items_table(row: 1) { expect(page).to have_content sub_menu_item_2.title }
    within_menu_items_table(row: 2) { expect(page).to have_content sub_menu_item_1.title }

    check_menu_item(row: 1)
    check_menu_item(row: 2)
    click_on 'Actions'
    click_on 'Move menu item up'

    expect(page).to have_content 'Only one selected menu item at a time can be moved'
    uncheck_menu_item(row: 1)
    click_on 'Actions'
    click_on 'Move menu item up'

    expect(page).to have_content 'Successfully moved the menu item up one place'
    within_menu_items_table(row: 1) { expect(page).to have_content sub_menu_item_1.title }
    within_menu_items_table(row: 2) { expect(page).to have_content sub_menu_item_2.title }
  end

  it "download user data" do
    sub_menu_item = create(:sub_menu_item, title: "Health readings")
    create(:user_input, menu_item: sub_menu_item) # needed as otherwise no download user data action will be shown
    create(:user_data_collection, menu_item: sub_menu_item, data: { "heart_rate" => 72 },
      created_at: DateTime.parse("2025-04-01"))
    create(:user_data_collection, menu_item: sub_menu_item, data: { "blood_pressure" => "120/80" },
      created_at: DateTime.parse("2025-04-05"))
    create(:user_data_collection, menu_item: sub_menu_item, data: { "health" => "Good" },
      created_at: DateTime.parse("2025-04-03"))

    visit avo.resources_menu_item_path(sub_menu_item)
    within_top_panel { click_on 'Actions' }
    click_on 'Download user data CSV'
    click_on 'Run'

    expect(page).to have_content 'Successfully downloaded user data'
    expected_user_data_collection_csv = <<~CSV
      msisdn,created at,blood_pressure,health,heart_rate
      254700000000,2025-04-05 00:00:00 UTC,120/80,,
      254700000000,2025-04-03 00:00:00 UTC,,Good,
      254700000000,2025-04-01 00:00:00 UTC,,,72
    CSV
    expect_file_download_to_eq expected_user_data_collection_csv

    within_top_panel { click_on 'Actions' }
    click_on 'Download user data CSV'
    first('input#fields_created_at_from', visible: false).set('2025-04-03')
    first('input#fields_created_at_to', visible: false).set('2025-04-03')
    click_on 'Run'

    expect(page).to have_content 'Successfully downloaded user data'
    expected_user_data_collection_csv = <<~CSV
      msisdn,created at,health
      254700000000,2025-04-03 00:00:00 UTC,Good
    CSV
    expect_file_download_to_eq expected_user_data_collection_csv
  end
end
