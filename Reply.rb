require './QuestionsDatabase.rb'

class Reply
  
  def self.all
    replies = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    replies.map {|reply| User.new(reply)}
  end
  
  attr_reader :id
  
  attr_accessor :subject_question_id, :parent_reply_id, :body 
  def initialize(options = {})
    @id = options['id']
    @subject_question_id = options['subject_question_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
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
end