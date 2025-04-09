describe UserInput do
  describe "normalizations" do
    it "makes key lowercase and replaces spaces with underscores" do
      user_input = create(:user_input, key: "Test  Key")
      expect(user_input.key).to eq "test_key"
    end
  end
end
