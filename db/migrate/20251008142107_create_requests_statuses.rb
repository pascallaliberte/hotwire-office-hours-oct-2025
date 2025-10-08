class CreateRequestsStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :requests_statuses do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.string :slug
      t.string :color

      t.timestamps
    end
  end
end
