class Directory < ApplicationRecord
    validates :display_name, presence: true
end
