class CreateQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :queries do |t|
      t.string :query
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
