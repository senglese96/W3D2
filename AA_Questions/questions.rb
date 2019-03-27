require_relative "replies"

class Questions
  def initialize(data_hash = {})
    @id = data_hash['id']
    @author_id = data_hash['author_id']
    @title = data_hash['title']
    @body = data_hash['body']
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
      WHERE
        id = #{id}
      SQL
    Questions.new(data[0])
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = #{author_id}
      SQL

    data.map! { |el| Questions.new(el) }
    data
  end

  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def author
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
      WHERE
        id = #{@author_id}
      SQL
    Users.new(data[0])
  end

  def replies
    Replies.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLikes.likers_for_question_id(@id)
  end

  def num_likes 
    QuestionLikes.num_likes_for_question_id(@id)
  end

end
