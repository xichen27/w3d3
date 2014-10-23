class User < ActiveRecord::Base
  
  validates :email, :presence => true, :uniqueness => true
    
  has_many(
    :submitted_urls,
    class_name: "ShortenedUrl",
    foreign_key: :user_id,
    primary_key: :id
  )
  
  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :user_id,
    primary_key: :id
  )
  
  has_many(
    :visited_urls,
    -> { distinct },
    through: :visits,
    source: :short_url
  )
  
  def num_submissions
    submitted_urls.count
  end
  
  def num_recent_submissions
    submitted_urls.where("created_at <= ?", 1.minute.ago).count
  end
end