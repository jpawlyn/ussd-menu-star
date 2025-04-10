describe MenuItem do
  describe "validations" do
    it "is invalid to create a second main menu item for the same account" do
      main_menu_item = create(:main_menu_item)
      expect(build(:main_menu_item, account: main_menu_item.account)).to be_invalid
    end

    it "is valid to create main menu items for different accounts" do
      create(:main_menu_item)
      expect(build(:main_menu_item)).to be_valid
    end

    it "is invalid to change a main menu item to point to a sub menu item" do
      sub_menu_item = create(:sub_menu_item)
      main_menu_item = sub_menu_item.menu_item
      main_menu_item.menu_item = sub_menu_item
      expect(main_menu_item).to be_invalid
    end

    it "is invalid to create a circular reference" do
      menu_item = create(:sub_menu_item)
      sub_menu_item = create(:sub_menu_item, menu_item:, account: menu_item.account)
      sub_sub_menu_item = create(:sub_menu_item, menu_item: sub_menu_item, account: sub_menu_item.account)
      menu_item.menu_item = sub_sub_menu_item
      expect(menu_item).to be_invalid
    end

    it "is invalid to reference itself" do
      sub_menu_item = create(:sub_menu_item)
      sub_menu_item.menu_item = sub_menu_item
      expect(sub_menu_item).to be_invalid
    end

    it "is invalid to reference a menu item belonging to a different account" do
      main_menu = create(:main_menu_item)
      sub_menu_item = create(:sub_menu_item)
      sub_menu_item.menu_item = main_menu
      expect(sub_menu_item).to be_invalid
    end

    it "is invalid to create a sub menu for a menu item with existing user inputs" do
      menu_item = create(:sub_menu_item)
      create(:user_input, menu_item: menu_item)
      sub_menu_item = build(:sub_menu_item, menu_item:, account: menu_item.account)
      expect(sub_menu_item).to be_invalid
    end
  end

  describe "#hierarchy" do
    let(:menu_item) { create(:sub_menu_item) }
    let(:account) { menu_item.account }
    let(:level_2_menu_item_1) { create(:sub_menu_item, menu_item:, account:) }
    let(:level_2_menu_item_2) { create(:sub_menu_item, menu_item:, account:) }
    let(:level_3_menu_item_1) { create(:sub_menu_item, menu_item: level_2_menu_item_1, account:) }

    it "returns all menu items in order" do
      expect(menu_item.hierarchy).to eq [ menu_item, level_2_menu_item_1, level_2_menu_item_2, level_3_menu_item_1 ]
    end

    it "returns level_2_menu_item_1 and children" do
      expect(level_2_menu_item_1.hierarchy).to eq [ level_2_menu_item_1, level_3_menu_item_1 ]
    end

    it "returns level_2_menu_item_2 only as there no children" do
      expect(level_2_menu_item_2.hierarchy).to eq [ level_2_menu_item_2 ]
    end
  end
end
