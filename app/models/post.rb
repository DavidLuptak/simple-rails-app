class Post < ActiveRecord::Base
  validates_presence_of :author
  validates_presence_of :title
  validates_presence_of :body

  has_and_belongs_to_many :tags, dependent: :destroy

  # accepts_nested_attributes_for :tags

  attr_accessor :tags_string
  validates :tags_string, presence: { message: "must have at least one tag" }

  before_save :handle_tags

  def handle_tags
    self.tags = []
    tags_from_input = tags_string.split(/[,\s]+/).uniq
    tags_from_input.each do |tag|
      self.tags << Tag.find_or_create_by!(:name => tag)
    end
  end

end
