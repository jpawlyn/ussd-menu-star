require "csv"

class Avo::Actions::MenuItem::DownloadUserData < Avo::BaseAction
  COLUMNS = [ "msisdn", "created at" ].freeze
  self.name = "Download user data CSV"
  self.no_confirmation = false
  self.standalone = true
  self.visible = -> do
    view == :show && resource.record.user_inputs?
  end

  def fields
    field :created_at_from, as: :date, placeholder: "From"
    field :created_at_to, as: :date, placeholder: "To"
  end

  def handle(records:, fields:, resource:, **args)
    created_at_from = Date.parse(fields[:created_at_from]).beginning_of_day if fields[:created_at_from].present?
    created_at_to = Date.parse(fields[:created_at_to]).end_of_day if fields[:created_at_to].present?

    user_data_collections = fetch_user_data_collections(created_at_from, created_at_to)
    if user_data_collections.empty?
      error "No data found"
      return keep_modal_open
    end

    file = generate_csv_file(user_data_collections)
    download file, file_name
    succeed "Successfully downloaded user data"
  end

  private

  def fetch_user_data_collections(created_at_from, created_at_to)
    resource.record.user_data_collections.where(created_at: created_at_from..created_at_to)
  end

  def generate_csv_file(user_data_collections)
    CSV.generate(headers: true) do |csv|
      csv << COLUMNS + fetch_columns_for_csv(user_data_collections)

      user_data_collections.each do |user_data_collection|
        csv << ([ user_data_collection.msisdn, user_data_collection.created_at ] +
          fetch_user_input_values(user_data_collection))
      end
    end
  end

  def file_name
    "user-data-for-#{resource.record.title.downcase.gsub(" ", "-")}-#{DateTime.current.to_s[..-7]}.csv"
  end

  def fetch_columns_for_csv(user_data_collections)
    @fetch_columns_for_csv ||= begin
      user_data_collections.each_with_object([]) do |next_value, result|
        next_value.data.keys.each { |key| result << key unless result.include?(key) }
      end
    end
  end

  def fetch_user_input_values(user_data_collection)
    @fetch_columns_for_csv.map { |key| user_data_collection.data[key] }
  end
end
