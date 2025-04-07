class Avo::Resources::Session < Avo::BaseResource
  self.record_selector = false
  self.includes = [ :user ]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user, as: :belongs_to, readonly: true
    field :ip_address, as: :text
    field :user_agent, as: :text
    field :created_at, as: :date_time, format: "dd.LL.yyyy TT", sortable: true, only_on: :index
  end
end
