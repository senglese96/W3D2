PRAGMA foreign_keys = ON;
DROP TABLE question_likes;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname,lname)
VALUES
  ('Sam', 'Inglese'),
  ('Carlos', 'Garcia');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('Why?', 'I mean just...why?', (SELECT id FROM users WHERE fname = 'Sam')),
  ('Pero?', 'Pero like why?', (SELECT id FROM users WHERE fname = 'Carlos'));

INSERT INTO
  question_follows(author_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Sam'), 
  (SELECT id FROM questions WHERE title = 'Pero?')),
  ((SELECT id FROM users WHERE fname = 'Sam'), 
  (SELECT id FROM questions WHERE title = 'Why?')),
  ((SELECT id FROM users WHERE fname = 'Carlos'), 
  (SELECT id FROM questions WHERE title = 'Pero?'));

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Pero?'), NULL,
  (SELECT id FROM users WHERE fname = 'Sam'),
  'Porque no hablo Inglese');

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES 
  ((SELECT id FROM questions WHERE title = 'Pero?'), 
  (SELECT id FROM replies WHERE body = 'Porque no hablo Inglese'),
  (SELECT id FROM users WHERE fname = 'Carlos'),
  'porque it be like that sometimes?');

INSERT INTO 
  question_likes(user_id,question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Sam'), 
  (SELECT id FROM questions WHERE title = 'Pero?')),
  ((SELECT id FROM users WHERE fname = 'Carlos'), 
  (SELECT id FROM questions WHERE title = 'Pero?'));




