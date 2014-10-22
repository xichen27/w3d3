require './QuestionsDatabase.rb'
require './SaveModel.rb'


class Reply
  include SaveModel
  
  
  def self.all
    replies = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    replies.map {|reply| User.new(reply)}
  end
  
  attr_reader :id
  
  attr_accessor :subject_question_id, :parent_reply_id, :body, :user_id
  def initialize(options = {})
    @id = options['id']
    @subject_question_id = options['subject_question_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def self.find_by_id
    
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE 
      id = ?
    SQL
    
    hash = QuestionDatabase.instance.execute(query, id).first
    self.class.new(hash)
  end
  
  def table_name
    'replies'
  end
  
  def var_name
    'subject_question_id, parent_reply_id, body, user_id'
  end
  
  def question_marks
    '?, ?, ?, ?'
  end
  
  def self.find_by_question_id(question_id)
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE 
      subject_question_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, question_id)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def self.find_by_user_id(user_id)
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE 
      user_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, user_id)
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
    
  def question
    query = <<-SQL
    SELECT
      *
    FROM
      questions
    WHERE 
      id = ?
    SQL
  
    array = QuestionDatabase.instance.execute(query, subject_question_id)
    array.map! { |hash| self.class.new(hash) }
  end  
    
  def parent_reply
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE 
      id = ?
    SQL
  
    array = QuestionDatabase.instance.execute(query, parent_reply_id)
    array.map! { |hash| self.class.new(hash) }
  end 
  
  def child_replies
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE 
      parent_reply_id = ?
    SQL
  
    array = QuestionDatabase.instance.execute(query, id)
    array.map! { |hash| self.class.new(hash) }
  end 
    
end