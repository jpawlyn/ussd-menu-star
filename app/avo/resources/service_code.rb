class Avo::Resources::ServiceCode < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :country_code, as: :select, name: "Country", include_blank: true, options: {
      Ghana: "GHA",
      Kenya: "KEN",
      Malawi: "MWI",
      Namibia: "NAM",
      Nigeria: "NGA",
      Rwanda: "RWA",
      "South Africa": "ZAF",
      Tanzania: "TZA",
      Uganda: "UGA",
      Zambia: "ZMB"
    }
    field :number, as: :text, placeholder: "*384*2401#"
    field :short_name, as: :text
    field :accounts, as: :has_many
  end
end
