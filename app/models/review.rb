class Review < ApplicationRecord
  validates :business_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :rating, presence: true
  validates :date, presence: true
  validates :loan_type, presence: true
  validates :review_type, presence: true

  validates :content, uniqueness: true
end
