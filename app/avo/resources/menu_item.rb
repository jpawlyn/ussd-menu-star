class Avo::Resources::MenuItem < Avo::BaseResource
  self.record_selector = true
  self.title = :avo_name
  self.includes = [ :menu_item, :account ]
  self.search = {
    query: -> { query.ransack(title_start: params[:q], m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :content, as: :textarea
    field :menu_item, as: :belongs_to, placeholder: "", attach_scope: -> {
      query.joins(:account).order(accounts: { name: :asc }).order(:position) }
    field :account, as: :belongs_to
    field :menu_items, as: :has_many, hide_search_input: true, discreet_pagination: true
  end

  def actions
    action Avo::Actions::MenuItem::MoveUp, icon: "heroicons/outline/arrow-small-up"
    action Avo::Actions::MenuItem::MoveDown, icon: "heroicons/outline/arrow-small-down"
  end
end
