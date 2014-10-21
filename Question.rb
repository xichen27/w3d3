require './QuestionsDatabase.rb'
require './Reply.rb'
require './QuestionFollower.rb'

class Question
  
  def self.all
    questions = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    questions.map {|question| User.new(question)}
  end
  
  attr_reader :id
  
  attr_accessor :title, :body, :user_id 
  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def self.find_by_id(id)
    
    query = <<-SQL
    SELECT
      *
    FROM
      questions
    WHERE 
      id = ?
    SQL
    
    hash = QuestionDatabase.instance.execute(query, id).first
    self.class.new(hash)
  end
  
  def self.find_by_author_id(author_id)
    query = <<-SQL
    SELECT
      *
    FROM
      questions
    WHERE 
      user_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, author_id)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def author
    query = <<-SQL
    SELECT
      *
    FROM
      users
    WHERE 
      id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, user_id)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def replies
    Reply.find_by_question_id(id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(id)
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
    
end