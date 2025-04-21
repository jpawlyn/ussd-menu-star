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
end
