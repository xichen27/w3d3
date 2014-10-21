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
  
  def self.follower_for_question_id(question_id)
    
    query = <<-SQL
    SELECT
      u.*
    FROM
      users u
    JOIN
      question_followers
    ON
      user_id = u.id
    WHERE 
      question_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, question_id)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    
    query = <<-SQL
    SELECT
      q.*
    FROM
      questions q
    JOIN
      question_followers
    ON
      question_id = q.id
    WHERE 
      user_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, user_id)
    array.map! { |hash| self.class.new(hash) }
  end
end
