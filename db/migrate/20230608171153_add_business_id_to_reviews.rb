class AddBusinessIdToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :business_id, :integer
  end
end
