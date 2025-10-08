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
    raise "please review and implement `valid_customers` in `app/models/request.rb`."
    # please specify what objects should be considered valid for assigning to `customer`.
    # the resulting code should probably look something like `team.customers`.
  end

  # 🚅 add methods above.
end
