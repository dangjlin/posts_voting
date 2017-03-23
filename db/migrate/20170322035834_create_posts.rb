class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.integer :goodvote, null: false, default: 0
      t.integer :badvote, null: false, default: 0

      t.timestamps null: false
    end
  end
end
