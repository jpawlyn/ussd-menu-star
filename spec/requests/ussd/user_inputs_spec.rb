describe "User input" do
  let(:main_menu) {  create(:main_menu_item) }
  let!(:sub_menu_item) do
    create(:sub_menu_item, menu_item: main_menu, title: "Provide health readings", content: "Thank you!", account:)
  end
  let!(:user_input1) do
    create(:user_input, menu_item: sub_menu_item, data_type: :integer, content: "What is your blood pressure reading?")
  end
  let!(:user_input2) do
    create(:user_input, menu_item: sub_menu_item, data_type: :text, content: "How do you feel today?", max_length: 10)
  end
  let(:account) { main_menu.account }
  let(:service_code) { account.service_code }
  let(:params) { { text: "", phoneNumber: "256721232323", sessionId:  "e2380764-0260-4d43-bf31-dc0d4db6e3ba" } }
  let(:expected_main_menu_response) do
    "CON 1 #{sub_menu_item.title}"
  end

  before do
    Rails.cache.clear # relying on memory store so need to clear before each ussd test
  end

  it "provide user health readings input" do
    post(ussd_callback_path(service_code.country_code, service_code.short_name), params:)
    expect(response.body).to eq expected_main_menu_response

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "1"))
    expect(response.body).to eq "CON #{user_input1.content}"

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "123"))
    expect(response.body).to eq "CON #{user_input2.content}"

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "Good"))
    expect(response.body).to eq "CON #{sub_menu_item.content}\n\n0 Back"
  end

  it "provide incorrect data type" do
    post(ussd_callback_path(service_code.country_code, service_code.short_name), params:)
    expect(response.body).to eq expected_main_menu_response

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "1"))
    expect(response.body).to eq "CON #{user_input1.content}"

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "123.3"))
    expect(response.body).to eq "CON You must enter an integer\n\n#{user_input1.content}"

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "123"))
    expect(response.body).to eq "CON #{user_input2.content}"

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "Good"))
    expect(response.body).to eq "CON #{sub_menu_item.content}\n\n0 Back"
  end

  it "provide invalid length input" do
    post(ussd_callback_path(service_code.country_code, service_code.short_name), params:)
    expect(response.body).to eq expected_main_menu_response

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "1"))
    expect(response.body).to eq "CON #{user_input1.content}"

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "123"))
    expect(response.body).to eq "CON #{user_input2.content}"

    post(ussd_callback_path(service_code.country_code, service_code.short_name),
      params: params.merge(text: "I feel so good!"))
    expect(response.body).to eq "CON Input must be no more than 10 characters\n\n#{user_input2.content}"

    post(ussd_callback_path(service_code.country_code, service_code.short_name), params: params.merge(text: "Good"))
    expect(response.body).to eq "CON #{sub_menu_item.content}\n\n0 Back"
  end
end
