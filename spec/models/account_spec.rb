describe Account do
  describe "relationships" do
    describe "menu_items" do
      let!(:account) { menu_item.account }
      let!(:menu_item) { create(:main_menu_item) }
      let!(:level_2_menu_item_1) { create(:sub_menu_item, menu_item:, account:) }
      let!(:level_3_menu_item_1) { create(:sub_menu_item, menu_item: level_2_menu_item_1, account:) }
      let!(:level_2_menu_item_2) { create(:sub_menu_item, menu_item:, account:) }
      let!(:menu_item_2) { create(:menu_item) }

      before do
        level_2_menu_item_1.move_lower
      end

      it "returns all menu items for account ordered by depth and position" do
        expect(account.menu_items)
          .to eq [ menu_item, level_2_menu_item_2, level_2_menu_item_1, level_3_menu_item_1 ]
      end
    end
  end

  describe "#main_menu_item" do
    let!(:menu_item) { create(:main_menu_item) }

    it "returns the account's main menu item" do
      expect(menu_item.account.main_menu_item).to eq menu_item
    end
  end
end
