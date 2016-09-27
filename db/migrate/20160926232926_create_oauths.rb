class CreateOauths < ActiveRecord::Migration[5.0]
  def change
    create_table :oauths do |t|
      t.string :access_token
      t.string :bot_user_id
      t.string :bot_access_token
      t.string :team_id
      t.string :team_name
      t.references :user, index: true, unique: true, foreign_key: true

      t.timestamps
    end
  end
end
