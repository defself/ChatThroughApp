class CreateBots < ActiveRecord::Migration[5.0]
  def change
    create_table :bots do |t|
      t.boolean :alive, default: false
      t.references :chat_room, index: true, unique: true, foreign_key: true

      t.timestamps
    end
  end
end
