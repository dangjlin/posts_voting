class CreateVoteRecords < ActiveRecord::Migration
  def change
    create_table :vote_records do |t|
      t.string :name
      t.string :uuid
      t.string :ip
      t.string :idea
      t.integer :post_id

      t.timestamps null: false
    end
  end
end
