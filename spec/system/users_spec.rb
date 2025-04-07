describe 'User admin actions' do
  let(:user) { create(:user) }
  before do
    sign_in_as user
  end

  it 'creates a user and login as new user' do
    visit avo.resources_users_path
    click_on 'Create new user'
    fill_in 'Email address', with: 'hello@example.com'
    fill_in 'Password', with: 'secret123'
    click_on 'Save'

    expect(page).to have_content 'User was successfully created.'

    find('a[data-control="profile-dots"]').click
    accept_prompt { click_on 'Sign out' }
    fill_in 'email_address', with: 'hello@example.com'
    fill_in 'password', with: 'secret123'
    click_on 'Sign in'

    expect(page).to have_current_path(avo.resources_accounts_path)
  end

  it 'updates a user password and login with new password' do
    user = create(:user)

    visit avo.resources_users_path
    find(:xpath, "//td[contains(text(), '#{user.email_address}')]").click
    click_on "Edit"
    fill_in 'Password', with: 'secret123'
    click_on 'Save'

    expect(page).to have_content 'User was successfully updated.'

    find('a[data-control="profile-dots"]').click
    accept_prompt { click_on 'Sign out' }
    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: 'secret123'
    click_on 'Sign in'

    expect(page).to have_current_path(avo.resources_accounts_path)
  end
end
