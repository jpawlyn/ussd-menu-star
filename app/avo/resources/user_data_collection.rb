class Avo::Resources::UserDataCollection < Avo::BaseResource
  self.visible_on_sidebar = false
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :msisdn, as: :text
    field :data, as: :key_value
    field :menu_item, as: :belongs_to
    field :created_at, as: :date_time, format: "dd.LL.yyyy TT", sortable: true, only_on: [ :index, :show ]
  end
end
