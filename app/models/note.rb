class Note < ApplicationRecord
  # belongs_to :micropost
  # belongs_to :teacher
  # belongs_to :subject
  has_many :likes
end