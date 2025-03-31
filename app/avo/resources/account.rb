class Avo::Resources::Account < Avo::BaseResource
  self.record_selector = false
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :service_code, as: :belongs_to
    field :callback, as: :text, readonly: true do
      "/ussd_callback/#{record.service_code.country_code.downcase}/#{record.service_code.short_name}"
    end
    field :menu_items, as: :has_many, hide_search_input: true, discreet_pagination: true
  end
end
