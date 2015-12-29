# Post
class Post < ActiveRecord::Base
  attr_accessor :tags_string

  has_and_belongs_to_many :tags

  validates_presence_of :author
  validates_presence_of :title
  validates_presence_of :body
  validates :tags_string, presence: { message: 'must have at least one tag' }

  before_save :find_or_create_tags
  before_destroy :decrement_posts_count
  after_commit :remove_unused_tags

  def find_or_create_tags
    decrement_posts_count # due to update
    old_tags = Array.new(tags) # due to sorting
    self.tags = []
    parse_tags_string.each do |tag|
      tags << Tag.find_or_create_by!(name: tag)
    end
    increment_posts_count

    # sorting posts also when only tag changes
    self.updated_at = Time.now if old_tags.sort != tags.sort
  end

  def parse_tags_string
    tags_string.split(/[,\s]+/).uniq
  end

  def increment_posts_count
    tags.each do |tag|
      Tag.increment_counter('posts_count', tag.id)
    end
  end

  def decrement_posts_count
    tags.each do |tag|
      Tag.decrement_counter('posts_count', tag.id)
    end
  end

  def remove_unused_tags
    Tag.where(posts_count: 0).destroy_all
  end
end
