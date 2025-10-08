class Avo::Resources::RequestsStatus < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Requests::Status
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :slug, as: :text
    field :color, as: :text
  end
end
