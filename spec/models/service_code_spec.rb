describe ServiceCode do
  describe "normalizations" do
    it "makes short name lowercase and replaces spaces with hyphens" do
      service_code = create(:service_code, short_name: "Test  Code")
      expect(service_code.short_name).to eq "test-code"
    end
  end
end
