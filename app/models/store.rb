class Store < ApplicationRecord
	has_many :versions, dependent: :destroy
	validates :key, presence: true
end
