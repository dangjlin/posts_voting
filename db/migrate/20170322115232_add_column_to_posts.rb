class AddColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :vote_records_count, :integer
  end
end
