class Post < ActiveRecord::Base
  validates_presence_of :author
  validates_presence_of :title
  validates_presence_of :body

  has_and_belongs_to_many :tags

  def tags_string

  end
end
