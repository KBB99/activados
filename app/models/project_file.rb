class ProjectFile < ApplicationRecord
  mount_uploader :url, DocumentUploader
end
