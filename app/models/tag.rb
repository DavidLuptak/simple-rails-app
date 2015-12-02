class Tag < ActiveRecord::Base
  validates :name, presence: { message: "must have at least one tag" }, uniqueness: true

  has_and_belongs_to_many :posts

  extend FriendlyId
  friendly_id :name
end
