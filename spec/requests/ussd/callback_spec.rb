describe "Menu display and navigation" do
  let(:main_menu) {  create(:main_menu_item) }
  let!(:sub_menu_item_1) { create(:sub_menu_item, menu_item: main_menu, title: "This is top", account:) }
  let!(:sub_menu_item_2) { create(:sub_menu_item, menu_item: main_menu, title: "This is middle", content: "This is contentfulness", account:) }
  let!(:sub_menu_item_3) { create(:sub_menu_item, menu_item: main_menu, title: "This is bottom", account:) }
  let(:account) { main_menu.account }
  let(:service_code) { account.service_code }
  let(:params) { { text: "", phoneNumber: "256721232323", sessionId:  "e2380764-0260-4d43-bf31-dc0d4db6e3ba" } }
  let(:expected_main_menu_response) do
    "CON 1 #{sub_menu_item_1.title}\n2 #{sub_menu_item_2.title}\n3 #{sub_menu_item_3.title}"
  end

  before do
    # relying on memory store so need to clear before each ussd test
    # particularly relevant if there is more than one test of course 😄
    Rails.cache.clear
  end

  it "navigate from the main menu to the middle sub menu item and then back to the main menu" do
    post(ussd_callback_path(service_code.country_code, service_code.short_name), params:)
    expect(response.body).to eq expected_main_menu_response

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "2"))
    expect(response.body).to eq "CON #{sub_menu_item_2.content}\n\n0 Back"

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "0"))
    expect(response.body).to eq expected_main_menu_response
  end

  it "displays the main menu ordered by position" do
    sub_menu_item_1.move_lower
    sub_menu_item_3.move_higher
    sub_menu_item_3.move_higher

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params:)
    expect(response.body)
      .to eq "CON 1 #{sub_menu_item_3.title}\n2 #{sub_menu_item_2.title}\n3 #{sub_menu_item_1.title}"
  end
end
