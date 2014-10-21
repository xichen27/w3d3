require './QuestionsDatabase.rb'

class QuestionFollower
  
  def self.all
    question_followers = QuestionsDatabase.instance.execute('SELECT * FROM question_followers')
    question_followers.map {|question_follower| User.new(question_follower)}
  end
  
  attr_reader :id
  
  attr_accessor :question_id, :user_id 
  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def self.find_by_id
    
    query = <<-SQL
    SELECT
      *
    FROM
      question_followers
    WHERE 
      id = ?
    SQL
    
    hash = QuestionDatabase.instance.execute(query, id).first
    self.class.new(hash)
  end
end
