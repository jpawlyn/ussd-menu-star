describe UserInput do
  describe "validations" do
    it "is invalid to create a user input for a menu item with existing sub menu items" do
      menu_item = create(:sub_menu_item)
      create(:sub_menu_item, menu_item:, account: menu_item.account)
      user_input = build(:user_input, menu_item: menu_item)
      expect(user_input).to be_invalid
    end
  end

  describe "normalizations" do
    it "makes key lowercase and replaces spaces with underscores" do
      user_input = create(:user_input, key: "Test  Key")
      expect(user_input.key).to eq "test_key"
    end
  end

  describe "#validate_input" do
    context "when user input must be an integer" do
      let(:user_input) { create(:user_input, data_type: :integer) }

      it "returns nil for valid input" do
        expect(user_input.validate_input("123")).to be_nil
      end

      it "returns error for number input" do
        expect(user_input.validate_input("123.4")).to eq "You must enter an integer"
      end

      it "returns error for string input" do
        expect(user_input.validate_input("abc")).to eq "You must enter an integer"
      end

      it "returns error for no input" do
        expect(user_input.validate_input("")).to eq "No input given"
      end
    end

    context "when user input must be a number" do
      let(:user_input) { create(:user_input, data_type: :number) }

      it "returns nil for number input" do
        expect(user_input.validate_input("123.21")).to be_nil
      end

      it "returns nil for integer input" do
        expect(user_input.validate_input("123")).to be_nil
      end

      it "returns error for string input" do
        expect(user_input.validate_input("abc")).to eq "You must enter a number"
      end
    end

    context "when user input must be 3 characters in length" do
      let(:user_input) { create(:user_input, data_type: :text, min_length: 3, max_length: 3) }

      it "returns nil for number input" do
        expect(user_input.validate_input("UGD")).to be_nil
      end

      it "returns error for input of less than 3 characters" do
        expect(user_input.validate_input("UG")).to eq "Input must be at least 3 characters"
      end

      it "returns error for input of more than 3 characters" do
        expect(user_input.validate_input("UGDX")).to eq "Input must be no more than 3 characters"
      end
    end
  end
end
