describe 'Download user data' do
  let!(:account) { create(:account) }
  let(:user) { create(:user) }

  before do
    sign_in_as user
  end

  after do
    FileUtils.rm_rf(Rails.root.join('tmp/downloads').to_s)
  end

  it "download user data csv file" do
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
