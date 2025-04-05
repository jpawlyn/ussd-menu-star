describe 'Account admin actions' do
  let!(:service_code) { create(:service_code) }

  it 'creates an account' do
    visit avo.resources_accounts_path
    click_on 'Create new account'
    fill_in 'Name', with: 'Account 1'
    select service_code.name, from: 'Service code'
    click_on 'Save'

    expect(page).to have_content 'Account was successfully created.'
    expect(page).to have_content 'Account 1'
    expect(page).to have_content service_code.name
  end

  it 'updates an account' do
    account = create(:account)
    visit avo.resources_accounts_path
    find(:xpath, "//td[contains(text(), '#{account.name}')]").click
    click_on "Edit"
    fill_in 'Name', with: 'New name'
    click_on 'Save'

    expect(page).to have_content 'Account was successfully updated.'
    expect(page).to have_content 'New name'
  end
end
