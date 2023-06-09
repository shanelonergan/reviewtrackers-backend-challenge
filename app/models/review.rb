class Review < ApplicationRecord
  validates :business_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :rating, presence: true, :inclusion => 0..5
  validates :date, presence: true

  validates :content, uniqueness: true
end
