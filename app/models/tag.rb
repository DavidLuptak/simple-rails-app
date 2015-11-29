class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :posts

  extend FriendlyId
  friendly_id :name

  # def to_param
  #   self.name
  # end
end
