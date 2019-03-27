require_relative 'users'

class Replies
  def initialize(data_hash = {})
    @question_id = data_hash['question_id']
    @parent_id = data_hash['parent_id']
    @user_id = data_hash['user_id']
    @body = data_hash['body']
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = #{user_id}
      SQL

    data.map! { |el| Replies.new(el) }
    data
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = #{question_id}
      SQL
    data.map! { |el| Replies.new(el) }
    data
  end

  def author
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
      WHERE
        id = #{@user_id}
      SQL

    User.new(data[0])
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
      WHERE
        id = #{@parent_id}
      SQL

    return Reply.new(data[0]) unless data.empty?
    nil
  end

  def child_replies 
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = #{@id}
      SQL

    return data.map {|el| Replies.new(el)} unless data.empty?
    nil
  end
end
