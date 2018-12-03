class Message < ActiveRecord::Base
    # belongs_to :micropost
    # belongs_to :subject
    validates_presence_of :body, :user_id
  
    def message_time
      created_at.strftime("%m/%d/%y at %l:%M %p")
    end
end