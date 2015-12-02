class Post < ActiveRecord::Base
  validates_presence_of :author
  validates_presence_of :title
  validates_presence_of :body

  has_and_belongs_to_many :tags, dependent: :destroy

  # accepts_nested_attributes_for :tags

  attr_accessor :tags_string
  validates :tags_string, presence: { message: "must have at least one tag" }

  before_save :find_or_create_tags
  before_destroy :decrement_posts_count
  after_destroy :remove_unused_tags

  def find_or_create_tags
    decrement_posts_count # due to update
    self.tags = []
    parse_tags_string.each do |tag|
      self.tags << Tag.find_or_create_by!(:name => tag)
    end
    increment_posts_count
  end

  def parse_tags_string
    tags_string.split(/[,\s]+/).uniq
  end

  def increment_posts_count
    self.tags.each do |tag|
      Tag.increment_counter('posts_count', tag.id)
    end
  end

  def decrement_posts_count
    self.tags.each do |tag|
      Tag.decrement_counter('posts_count', tag.id)
    end
  end

  def remove_unused_tags
    Tag.where(posts_count: 0).destroy_all
  end

end
