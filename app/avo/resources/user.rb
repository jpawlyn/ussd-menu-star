class Avo::Resources::User < Avo::BaseResource
  self.record_selector = false
  self.title = :email_address
  self.includes = [ :sessions ]
  self.search = {
    query: -> { query.ransack(email_cont: params[:q], m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :email_address, as: :text
    field :password, as: :text, required: true, only_on: :forms
    field :created_at, as: :date_time, format: "dd.LL.yyyy TT", sortable: true, only_on: :index
    field :updated_at, as: :date_time, format: "dd.LL.yyyy TT", sortable: true, only_on: :index
    field :sessions, as: :has_many
  end
end
