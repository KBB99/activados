class Teacher < ApplicationRecord
    has_many :subjects
    has_many :notes
end