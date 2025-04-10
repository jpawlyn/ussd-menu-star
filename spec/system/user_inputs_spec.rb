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
end
