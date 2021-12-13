class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :msg ,presence: true, length: {maximum: 500}
  has_many :likes ,dependent: :destroy
  has_many :user_likes ,through: :likes, source: :user
end
