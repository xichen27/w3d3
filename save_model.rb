require 'active_support/inflector'
# Inflector.tableize('whatever')
module SaveModel

  
  def instance_variables
    Object.instance_variable.map { |el| el.to_s[1..-1] }
  end
  
  def save(var_names, question_marks)
    unless (the thing that is being saved).id.nil?
      query = <<-SQL
      UPDATE ?
      SET #{var_names} = #{question_marks}
      WHERE id = ?
      SQL
      QuestionsDatabase.instance.execute(query, table_name, var_names, id)
    else
      query = <<-SQL
      INSERT INTO ? (#{var_name})
      VALUES #{question_marks}
        SQL
      QuestionsDatabase.instance.execute(query, table_name, var_names, id)
      @id = QuestionsDatabase.instance.last_insert_row_id 
    end
  end
end


