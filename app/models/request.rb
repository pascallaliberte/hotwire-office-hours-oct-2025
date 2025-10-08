class Request < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :customer
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :customer, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_customers
    team.customers
  end

  # 🚅 add methods above.
end
