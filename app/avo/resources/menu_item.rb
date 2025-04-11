class Avo::Resources::MenuItem < Avo::BaseResource
  self.visible_on_sidebar = false
  self.record_selector = true
  self.title = :title
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
    field :terminate_session, as: :boolean
    field :account, as: :belongs_to, visible: -> { resource.record.menu_item.nil? }
    field :account_id, as: :hidden, default: -> { resource.record.menu_item.account.id }, only_on: :new,
        visible: -> { resource.record.menu_item }
    field :menu_items, as: :has_many,
      visible: -> { resource.record.menu_items.any? || resource.record.user_inputs.empty? },
      hide_search_input: true, discreet_pagination: true
    field :user_inputs, as: :has_many,
      visible: -> { resource.record.user_inputs.any? || resource.record.menu_items.empty? },
      hide_search_input: true, discreet_pagination: true
    field :user_data_collections, as: :has_many,
      visible: -> { resource.record.user_data_collections.any? },
      hide_search_input: true, discreet_pagination: true
  end

  def actions
    action Avo::Actions::MenuItem::MoveUp, icon: "heroicons/outline/arrow-small-up"
    action Avo::Actions::MenuItem::MoveDown, icon: "heroicons/outline/arrow-small-down"
  end
end
