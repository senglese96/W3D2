require_relative "questions_database"
require_relative "questions"
require_relative 'replies'

class Users
  attr_accessor :id, :fname, :lname

  def initialize(data_hash = {})
    @id = data_hash['id']
    @fname = data_hash['fname']
    @lname = data_hash['lname']
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
      WHERE
        id = #{id}
      SQL
    Users.new(data[0])
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
      WHERE
        fname = #{fname} AND lname = #{lname}
      SQL
    Users.new(data[0])
  end

  def authored_questions
    Questions.find_by_author_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_author_id(@id)
  end

  def liked_questions
    QuestionLikes.liked_questions_for_user_id(@id)
  end

  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        CAST(COUNT(user_id) AS FLOAT)/COUNT(DISTINCT(questions.id)) AS average
      FROM
        question_likes
      LEFT OUTER JOIN questions ON questions.id = question_likes.question_id
      WHERE
        author_id = #{@id}
      SQL
    data[0]['average']
  end

  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL)
        INSERT
          users(fname, lname)
        VALUES
          (#{@fname}, #{lname})
        SQL
      @id = QuestionsDatabase.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL)
        UPDATE
          users
        SET
          fname = #{@fname}, lname = #{@lname}
        WHERE
          id = #{@id}
        SQL
    end
  end
end
