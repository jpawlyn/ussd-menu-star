describe 'Sign in and sign out' do
  let(:user) { create(:user) }

  it 'user signs in and signs out' do
    visit "/"
    expect(page).to have_current_path(new_session_path)

    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: 'wrong-password'
    click_on 'Sign in'
    expect(page).to have_content 'Try another email address or password.'

    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: 'password'
    click_on 'Sign in'
    expect(page).to have_current_path(avo.resources_accounts_path)

    within('.avo-sidebar') do
      expect(page).to have_content 'Accounts'
      expect(page).to have_content 'Service codes'
      expect(page).to have_content 'Sessions'
      expect(page).to have_content 'Users'
    end

    find('a[data-control="profile-dots"]').click
    accept_prompt { click_on 'Sign out' }

    expect(page).to have_current_path(new_session_path)
  end
end
