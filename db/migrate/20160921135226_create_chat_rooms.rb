class CreateChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.integer :receiver_id

      t.timestamps
    end
  end
end
