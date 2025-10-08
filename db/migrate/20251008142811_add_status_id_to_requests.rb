class AddStatusIdToRequests < ActiveRecord::Migration[8.0]
  def change
    add_reference :requests, :status, null: true, foreign_key: {to_table: "requests_statuses"}
  end
end
