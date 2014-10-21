require './QuestionsDatabase.rb'

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
end