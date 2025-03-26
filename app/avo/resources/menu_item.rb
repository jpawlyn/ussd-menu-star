class Avo::Resources::MenuItem < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :content, as: :textarea
    field :menu_item, as: :belongs_to, placeholder: ""
    field :account, as: :belongs_to
    field :menu_items, as: :has_many
  end
end
