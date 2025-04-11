describe 'User input admin actions' do
  let!(:sub_menu_item) { create(:sub_menu_item) }
  let(:user) { create(:user) }
  before do
    sign_in_as user
  end

  it 'creates user input for submenu' do
    visit avo.resources_menu_item_path(sub_menu_item)
    click_on 'Create new user input'

    fill_in 'Key', with: 'heart_rate'
    fill_in 'Content', with: 'What is your heart rate?'
    click_on 'Save'

    expect(page).to have_content 'User input was successfully created.'
    expect(page).to have_content 'heart_rate'
  end

  it 'changes the ordering of user inputs' do
    user_input_1 = create(:user_input, menu_item: sub_menu_item)
    user_input_2 = create(:user_input, menu_item: sub_menu_item)

    visit avo.resources_menu_item_path(sub_menu_item)
    within_user_inputs_table(row: 1) { expect(page).to have_content user_input_1.key }
    within_user_inputs_table(row: 2) { expect(page).to have_content user_input_2.key }
    click_on 'Actions'
    click_on 'Move user input down'

    expect(page).to have_content 'No user input selected'
    check_user_input(row: 1)
    click_on 'Actions'
    click_on 'Move user input down'

    expect(page).to have_content 'Successfully moved the user input down one place'
    within_user_inputs_table(row: 1) { expect(page).to have_content user_input_2.key }
    within_user_inputs_table(row: 2) { expect(page).to have_content user_input_1.key }

    check_user_input(row: 1)
    check_user_input(row: 2)
    click_on 'Actions'
    click_on 'Move user input up'

    expect(page).to have_content 'Only one selected user input at a time can be moved'
    uncheck_user_input(row: 1)
    click_on 'Actions'
    click_on 'Move user input up'

    expect(page).to have_content 'Successfully moved the user input up one place'
    within_user_inputs_table(row: 1) { expect(page).to have_content user_input_1.key }
    within_user_inputs_table(row: 2) { expect(page).to have_content user_input_2.key }
  end
end
