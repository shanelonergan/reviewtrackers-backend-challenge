class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :content
      t.string :author
      t.string :rating
      t.string :date
      t.boolean :closed
      t.string :loan_type
      t.string :review_type

      t.timestamps
    end
  end
end
