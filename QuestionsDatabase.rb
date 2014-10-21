require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    
    self.results_as_hash = true
    
    self.type_translation = true
  end

end

class User
  def self.all
    users = QuestionsDatabase.instance.execute('SELECT * FROM users')
    users.map {|user| User.new(user)}
  end
  
  attr_accessor :id, :fname, :lname  
  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def self.find_by_id
  end
end

class Question
  
  def self.all
    questions = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    questions.map {|question| User.new(question)}
  end
  
  attr_accessor :id, :title, :body, :user_id 
  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def self.find_by_id
  end
end

class QuestionFollower
  
  def self.all
    question_followers = QuestionsDatabase.instance.execute('SELECT * FROM question_followers')
    question_followers.map {|question_follower| User.new(question_follower)}
  end
  
  attr_accessor :id, :question_id, :user_id 
  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def self.find_by_id
  end
end

class Reply
  
  def self.all
    replies = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    replies.map {|reply| User.new(reply)}
  end
  
  attr_accessor :id, :subject_question_id, :parent_reply_id, :body 
  def initialize(options = {})
    @id = options['id']
    @subject_question_id = options['subject_question_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
  end
  
  def self.find_by_id
  end
end

class QuestionLike
  
  def self.all
    questions_likes = QuestionsDatabase.instance.execute('SELECT * FROM questions_likes')
    questions_likes.map {|question_like| User.new(question_like)}
  end
  
  attr_accessor :id, :question_id, :user_id 
  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def self.find_by_id
  end
end