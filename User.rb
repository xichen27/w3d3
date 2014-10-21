require './QuestionsDatabase.rb'
require './Reply.rb'
require './QuestionFollower.rb'
require './QuestionLike.rb'

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
    
    hash = QuestionsDatabase.instance.execute(query, id).first
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
    
    array = QuestionsDatabase.instance.execute(query, fname, lname)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def authored_questions
    Reply.find_by_user_id(id)
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
    
    array = QuestionsDatabase.instance.execute(query, id)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end
  
  def average_karma
    query = <<-SQL
    SELECT
      SUM(likes_per_q) / CAST(COUNT(DISTINCT ques) AS FLOAT) 
    FROM
    (
      SELECT
        q.id ques, COUNT(ql.user_id) likes_per_q
      FROM
        questions q
      LEFT OUTER JOIN
        question_likes ql
      ON
        q.id = ql.question_id
      WHERE 
        q.user_id = ?
      GROUP BY 
        question_id
    )  
    SQL
    
    QuestionsDatabase.instance.execute(query, id)
  end
end