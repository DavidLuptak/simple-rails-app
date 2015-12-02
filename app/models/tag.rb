# Tag
class Tag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  has_and_belongs_to_many :posts, counter_cache: true

  validates :name,
            presence: { message: 'must have at least one tag' },
            uniqueness: true
end
