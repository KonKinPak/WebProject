class Post < ApplicationRecord
  self.per_page = 5
  belongs_to :user
  has_one_attached :banner
  has_rich_text :body
  validates :title ,presence: true ,uniqueness: true ,length: { in:3..100}
  validates :body ,presence: true 
  #,length: { minimum: 25}

  has_many :likes ,dependent: :destroy
  has_many :comments ,dependent: :destroy
  has_many :user_likes ,through: :likes, source: :user
  
  def optimized_image(image,x,y)
    return image.variant(resize_to_fill: [x,y]).processed
  end

end
