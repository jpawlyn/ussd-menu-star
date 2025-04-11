module DownloadFileHelpers
  def expect_file_download_to_eq(expect_contents)
    file = Dir.glob(Rails.root.join("tmp/downloads/*"))[0]
    contents = File.read(file)
    expect(contents).to eq expect_contents
    File.delete(file) # file cleanup also happens in after hook in the rails_helper
  end
end

RSpec.configure do |config|
  config.include DownloadFileHelpers, type: :system
end
