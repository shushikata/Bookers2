class Message < ApplicationRecord
  belongs_to :user
  belongs_to :receive_user, class_name: 'User'
end
