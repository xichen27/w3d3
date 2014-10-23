class TagTopic < ActiveRecord::Base
  
  validates :topic, presence: true, uniqueness: true
  
  # belongs_to(
  #   :submitter,
  #   class_name: 'User',
  #   foreign_key: :user_id,
  #   primary_key: :id
  # )
  
  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :tag_topic_id,
    primary_key: :id
  )
  
  has_many(
    :short_urls,
    -> { distinct }, 
    through: :taggings,
    source: :short_url
  )
  
end