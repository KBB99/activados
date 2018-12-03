class Subject < ApplicationRecord
    belongs_to :teacher
    has_many :project_files
    has_many :notes
    has_many :users
    has_many :messages, dependent: :destroy
end