class ShortenedUrl < ActiveRecord::Base
  
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, length: { maximum: 200 }
  validate :no_more_than_five_in_last_minute
  
  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )
  
  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :short_url_id,
    primary_key: :id
  )
  
  has_many(
    :visitors,
    -> { distinct }, 
    through: :visits,
    source: :visitor
  )
  
  has_many(
    :tag_topics,
    -> { distinct }, 
    through: :taggings,
    source: :tag_topic
  )
  
  def self.random_code
    loop do
      random_code = SecureRandom.urlsafe_base64
      unless ShortenedUrl.exists?(['short_url = ?', random_code])
        return random_code
      end
    end
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id)
  end
  
  def num_clicks
    visits.count
  end
  
  def num_uniques
    visitors.count
  end
  
  def num_recent_uniques
    visits.where("created_at <= ?", 10.minutes.ago).count
  end

  def no_more_than_five_in_last_minute
    if (submitter.num_recent_submissions > 5)
      self.errors << "Too many recent submissions!"
    end
  end
end








