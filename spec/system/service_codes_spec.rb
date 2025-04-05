describe 'Service code admin actions' do
  it 'creates a service code' do
    visit avo.resources_service_codes_path
    click_on 'Create new service code'
    fill_in 'Name', with: 'Mobile money'
    select 'Uganda', from: 'Country'
    fill_in 'Short name', with: 'testing'
    click_on 'Save'

    expect(page).to have_content 'Service code was successfully created.'
    expect(page).to have_content 'Mobile money'
    expect(page).to have_content 'Uganda'
    expect(page).to have_content 'testing'
  end

  it 'updates a service code' do
    service_code = create(:service_code)

    visit avo.resources_service_codes_path
    find(:xpath, "//td[contains(text(), '#{service_code.name}')]").click
    click_on "Edit"
    fill_in 'Name', with: 'New name'
    fill_in 'Short name', with: 'new-short'
    click_on 'Save'

    expect(page).to have_content 'Service code was successfully updated.'
    expect(page).to have_content 'New name'
    expect(page).to have_content 'new-short'
  end
end
