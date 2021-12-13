class User < ApplicationRecord
	self.per_page = 10
	validates :username,:nickname ,presence: true ,uniqueness: true
	validates :password ,presence: true 
	#length: { in:8..15}
	has_secure_password
	validates_confirmation_of :password, :message => "password confirmation should match password"
	has_many :posts ,dependent: :destroy
	has_many :likes ,dependent: :destroy
	has_many :comments ,dependent: :destroy

	has_many :follower_follows, foreign_key: :followee_id, class_name: "Follow" 
    has_many :followers, through: :follower_follows, source: :follower
    has_many :followee_follows, foreign_key: :follower_id, class_name: "Follow"
    has_many :followees, through: :followee_follows, source: :followee
   	
   	has_one_attached :avatar

  	scope :all_except, ->(user) { where.not(id: user) }
  	after_create_commit { broadcast_prepend_to "users" }
  	has_many :messages
   	
    def get_feed_post
	   posts = []
	   self.followees.each do |f|
	     f.posts.each do |p|
	       posts.push(p)
	     end
	   end
	   return posts.sort().reverse
   	end
end
