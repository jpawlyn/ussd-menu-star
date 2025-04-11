class Avo::Resources::UserInput < Avo::BaseResource
  self.visible_on_sidebar = false
  self.includes = [ :menu_item ]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :key, as: :text
    field :content, as: :textarea, required: true
    field :data_type, as: :select, enum: ::UserInput.data_types
    field :min_length, as: :number
    field :max_length, as: :number
    field :menu_item, as: :belongs_to
  end

  def actions
    action Avo::Actions::UserInput::MoveUp, icon: "heroicons/outline/arrow-small-up"
    action Avo::Actions::UserInput::MoveDown, icon: "heroicons/outline/arrow-small-down"
  end
end
