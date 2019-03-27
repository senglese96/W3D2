require_relative 'users'

class QuestionFollows
  def initialize(data_hash)
    @id = data_hash['id']
    @author_id = data_hash['author_id']
    @question_id = data_hash['question_id']
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = #{id}
      SQL
    QuestionFollows.new(data[0])
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        users.id,fname,lname
      FROM
        question_follows
      JOIN users ON users.id = question_follows.author_id
      WHERE
        question_id = #{question_id}
      SQL
    data.map{ |el| Users.new(el)}
  end

  def self.followed_questions_for_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.id,body,title,questions.author_id
      FROM
        question_follows
      JOIN questions ON questions.id = question_follows.question_id
      WHERE
        author_id = #{author_id}
      SQL
    data.map{ |el| Questions.new(el)}
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.id,body,title,questions.author_id
      FROM
        question_follows
      JOIN questions ON questions.id = question_follows.question_id
      GROUP BY
        question_id
      ORDER BY COUNT(question_follows.author_id) DESC
      LIMIT #{n}
      SQL
  end
end
