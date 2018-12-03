class Micropost < ApplicationRecord
  # belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :project_files, dependent: :destroy
  has_and_belongs_to_many :users
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :name, presence: true
  validates :content, presence: true
  has_many :messages, dependent: :destroy


  # private

    # Validates the size of an uploaded picture.
    # def picture_size
    #   if picture.size > 5.megabytes
    #     errors.add(:picture, "should be less than 5MB")
    #   end
    # end

    # def document_size
    #   if document.size > 5.megabytes
    #     errors.add(:document, "should be less than 5MB")
    #   end
    # end
end