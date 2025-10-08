class Request < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :customer
  belongs_to :status, class_name: "Requests::Status", optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :customer, scope: true
  validates :status, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_customers
    team.customers
  end

  def valid_statuses
    team.requests_statuses
  end

  # 🚅 add methods above.
end
