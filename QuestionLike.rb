require './QuestionsDatabase.rb'
require './SaveModel.rb'


class QuestionLike
  
  include SaveModel
  
  
  def self.all
    questions_likes = QuestionsDatabase.instance.execute('SELECT * FROM questions_likes')
    questions_likes.map {|question_like| User.new(question_like)}
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
      question_likes
    WHERE 
      id = ?
    SQL
    
    hash = QuestionDatabase.instance.execute(query, id).first
    self.class.new(hash)
  end

  
  def self.likers_for_question_id(question_id)
    
    query = <<-SQL
    SELECT
      u.*
    FROM
      users u
    JOIN
      question_likers
    ON
      user_id = u.id
    WHERE 
      question_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, question_id)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def self.num_likes_for_question_id(question_id)
  
    query = <<-SQL
    SELECT
      count(user_id)
    FROM
      users u
    JOIN
      question_likers
    ON
      user_id = u.id
    WHERE 
      question_id = ?
    SQL
  
    QuestionDatabase.instance.execute(query, question_id)
  end
  
  def self.liked_questions_for_user_id(user_id)
    
    query = <<-SQL
    SELECT
      q.*
    FROM
      questions q
    JOIN
      question_likes
    ON
      question_id = q.id
    WHERE 
      user_id = ?
    SQL
    
    array = QuestionDatabase.instance.execute(query, user_id)
    array.map! { |hash| self.class.new(hash) }
  end
  
  def self.most_liked_questions(n)
    
    query = <<-SQL
    SELECT
      *
    FROM
      questions 
    WHERE id =
    (SELECT
      question_id
    FROM
       question_likes
    GROUP BY
      question_id)
    ORDER BY
      Count(user_id)
    LIMIT ?)
    SQL
        
    array = QuestionDatabase.instance.execute(query, n)
    array.map! { |hash| self.class.new(hash) }
  end
  
  
  
end