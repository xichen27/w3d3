reqiure './QuestionsDatabase.rb'

class QuestionLike
  
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
end