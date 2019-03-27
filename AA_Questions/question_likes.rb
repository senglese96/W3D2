require_relative 'questions_database'
require_relative 'users'

class QuestionLikes
  def initialize(data_hash)
    @user_id = data_hash['user_id']
    @question_id = data_hash['question_id']
  end

  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        fname,lname,users.id
      FROM
        users
      JOIN question_likes ON users.id = question_likes.user_id
      WHERE
        question_id = #{question_id}
      SQL
    data.map { |el| Users.new(el) }
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        COUNT(user_id)
      FROM
        question_likes
      WHERE
        question_id = #{question_id}
      SQL
    data[0]['COUNT(user_id)']
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.id,title,body,author_id
      FROM
        questions
      JOIN question_likes ON questions.id = question_likes.question_id
      WHERE
        user_id = #{user_id}
      SQL
    data.map { |el| Questions.new(el) }
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.id,body,title,questions.author_id
      FROM
        question_likes
      JOIN questions ON questions.id = question_likes.question_id
      GROUP BY
        question_id
      ORDER BY COUNT(question_likes.user_id) DESC
      LIMIT #{n}
      SQL
      data.map { |el| Questions.new(el) }
  end
end
