CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(25) NOT NULL,
  lname VARCHAR(25) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(25) NOT NULL,
  body VARCHAR(1000) NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  body VARCHAR(1000) NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
('Adam', 'Berman'),
('Xi', 'Chen');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('SQL ?', 'How does SQL work? Someone tell me! Please!', (SELECT id FROM users WHERE fname = 'Xi')),
  ('Jobs', 'When can we get them?', (SELECT id FROM users WHERE fname = 'Adam'));
  
INSERT INTO
  question_followers (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'SQL ?'), (SELECT id FROM users WHERE fname = 'Adam')),
  ((SELECT id FROM questions WHERE title = 'Jobs'), (SELECT id FROM users WHERE fname = 'Xi')),
  ((SELECT id FROM questions WHERE title = 'SQL ?'), (SELECT id FROM users WHERE fname = 'Xi')),
  ((SELECT id FROM questions WHERE title = 'Jobs'), (SELECT id FROM users WHERE fname = 'Adam'));

INSERT INTO
  replies (subject_question_id, parent_reply_id, body, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'Jobs'), NULL, 'When we are done here!', (SELECT id FROM users WHERE fname = 'Xi')),
  ((SELECT id FROM questions WHERE title = 'Jobs'), (SELECT id FROM replies WHERE body = 'When we are done here!'), 'When is that?',
    (SELECT id FROM users WHERE fname = 'Adam'));

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'SQL ?'), (SELECT id FROM users WHERE fname = 'Adam')),
  ((SELECT id FROM questions WHERE title = 'Jobs'), (SELECT id FROM users WHERE fname = 'Xi')),
  ((SELECT id FROM questions WHERE title = 'SQL ?'), (SELECT id FROM users WHERE fname = 'Xi')),
  ((SELECT id FROM questions WHERE title = 'Jobs'), (SELECT id FROM users WHERE fname = 'Adam'));