class Link < ActiveRecord::Base
	validates :url, :presence => true
	validates :title, :presence => true

	belongs_to :user

	has_many :votes
end
