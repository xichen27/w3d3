require './QuestionsDatabase.rb'

class User
  def self.all
    users = QuestionsDatabase.instance.execute('SELECT * FROM users')
    users.map {|user| User.new(user)}
  end
  
  attr_reader :id
  
  attr_accessor :fname, :lname  
  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def self.find_by_id(id)
    
    query = <<-SQL
    SELECT
      *
    FROM
      users
    WHERE 
      id = ?
    SQL
    
    hash = QuestionDatabase.instance.execute(query, id).first
    self.class.new(hash)
  end
  
  def self.find_by_name(fname, lname)
    query = <<-SQL
    SELECT
      *
    FROM
      users
    WHERE 
      lname = ?
      fname = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, fname, lname)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def authored_questions
    query = <<-SQL
    SELECT
      *
    FROM 
      questions
    WHERE
      user_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, id)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def authored_questions
    query = <<-SQL
    SELECT
      *
    FROM 
      replies
    WHERE
      user_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, id)
    array.map! { |hash| self.class.new(hash) }
  end
  
end