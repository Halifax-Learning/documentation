USE hlc;

DROP TABLE IF EXISTS QuestionType, Question, Account, TestType, Test, TestQuestion;

CREATE TABLE QuestionType (
    question_type_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    instruction_text VARCHAR(255) NOT NULL,
    instruction_audio_filepath VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME
);

CREATE TABLE Question (
    question_id CHAR(32) PRIMARY KEY,
    question_type_id INT NOT NULL,
    question_text VARCHAR(255) NOT NULL,
    question_audio_filepath VARCHAR(255),
    correct_answer_text VARCHAR(255),
    correct_answer_audio_filepath VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (question_type_id) REFERENCES QuestionType(question_type_id)
);

CREATE TABLE Account (
    account_id CHAR(32) PRIMARY KEY,
    account_role VARCHAR(50) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    hashed_password VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME
);

CREATE TABLE TestType (
    test_type_id INT PRIMARY KEY,
    question_type_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    num_questions INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (question_type_id) REFERENCES QuestionType(question_type_id)
);

CREATE TABLE Test (
    test_id CHAR(32) PRIMARY KEY,
    test_type_id INT NOT NULL,
    test_taker_id CHAR(32),
    test_taker_name VARCHAR(100),
    test_taker_email VARCHAR(100),
    submission_time DATETIME,
    num_correct_answers INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (test_type_id) REFERENCES TestType(test_type_id),
    FOREIGN KEY (test_taker_id) REFERENCES Account(account_id)
);


CREATE TABLE TestQuestion (
    test_question_id CHAR(32) PRIMARY KEY,
    test_id CHAR(32) NOT NULL,
    question_id CHAR(32) NOT NULL,
    answer_text VARCHAR(255),
    answer_audio_filepath VARCHAR(255),
    human_evaluation BOOLEAN,
    human_evaluator_id CHAR(32),
    machine_evaluation FLOAT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (test_id) REFERENCES Test(test_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES Question(question_id) ON DELETE CASCADE,
    FOREIGN KEY (human_evaluator_id) REFERENCES Account(account_id)
);

INSERT INTO QuestionType (question_type_id, name, instruction_text, instruction_audio_filepath) VALUES
    (1, 'Synthesis', 'I''ll say two sounds, you tell me the word, like this: "/m/ /oo/" - "moo".', 'questions/synthesis/instruction_synthesis.mp3'),
    (2, 'Analysis', 'I''ll say a syllable, and you tell me the three sounds you hear, like this: "boot" - "/b/ /oo/ /t/".', NULL),
    (3, 'Listening', 'I''ll say a syllable, and you tell me the middle vowel sound, like this: "boot" - "/oo/".', NULL),
    (4, 'Single Phoneme Recognition', 'Look at the sound card. Tell me the sound.', NULL);

INSERT INTO Question(question_id, question_type_id, question_text, question_audio_filepath, correct_answer_audio_filepath) VALUES
    ('6caf748d6c9111ef8817bc2411ffed9d', 1, '/k/ /aw/', 'questions/synthesis/question_k_aw.mp3', NULL),
    ('923e6738203211ea8817bc2411ffed9d', 1, '/t/ /o_e/', 'questions/synthesis/question_t_oe.mp3', NULL),
    ('923e6738203211ea8817bc2411ffed3d', 1, '/t/ /a_e/', 'questions/synthesis/question_t_ae.mp3', NULL),
    ('923e6738203211ea8817bc2411ffed4d', 1, '/sh/ /oo/', 'questions/synthesis/question_sh_oo.mp3', NULL),
    ('923e6738203211ea8817bc2411ffed5d', 1, '/f/ /ee/', 'questions/synthesis/question_f_ee.mp3', NULL),
    ('123e6738203211ea8817bc2411ffed9d', 1, '/m/ /-a-/ /t/', 'questions/synthesis/question_m_a_t.mp3', NULL),
    ('223e6738203211ea8817bc2411ffed9d', 1, '/sh/ /oo/ /t/', 'questions/synthesis/question_sh_oo_t.mp3', NULL),
    ('323e6738203211ea8817bc2411ffed9d', 1, '/t/ /oy/ /m/', 'questions/synthesis/question_t_oy_m.mp3', NULL),
    ('423e6738203211ea8817bc2411ffed9d', 1, '/s/ /oo/ /m/', 'questions/synthesis/question_s_oo_m.mp3', NULL),
    ('523e6738203211ea8817bc2411ffed9d', 1, '/k/ /a_e/ /f/', 'questions/synthesis/question_k_ae_f.mp3', NULL);

INSERT INTO Account(account_id, account_role, first_name, last_name, email, username, hashed_password) VALUES
    ('58973104203211ea8817bc2411ffed9d', 'student', 'Student', '1', 'student.1@gmail.com', 'student1', 'password1'),
    ('7f8d6872203211ea8817bc2411ffed9d', 'teacher', 'Teacher', '1', 'teacher.1@gmail.com', 'teacher1', 'password1');

INSERT INTO TestType(test_type_id, question_type_id, name, num_questions) VALUES
    (1, 1, 'Synthesis', 5),
    (2, 2, 'Analysis', 5),
    (3, 3, 'Listening', 5),
    (4, 4, 'Single Phoneme Recognition', 5);