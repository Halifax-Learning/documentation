USE hlc;

DROP TABLE IF EXISTS Account, QuestionType, Question, AssessmentType, Assessment, TestType, Test, AssessmentTypeTestTypeMapping, TestQuestion, AutoGradingHistory, TeacherGradingHistory;

CREATE TABLE Account (
    account_id CHAR(32) PRIMARY KEY,
    account_role VARCHAR(50) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    hashed_password VARCHAR(255) NOT NULL,
    current_enrolled_course VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME
);

CREATE TABLE QuestionType (
    question_type_id INT PRIMARY KEY,
    question_type_name VARCHAR(100) NOT NULL,
    question_instruction_text VARCHAR(255) NOT NULL,
    instruction_audio_filepath VARCHAR(255),
    instruction_video_filepath VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME
);

CREATE TABLE Question (
    question_id INT PRIMARY KEY,
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


CREATE TABLE AssessmentType (
    assessment_type_id INT PRIMARY KEY,
    assessment_type_name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME
);

CREATE TABLE Assessment (
    assessment_id CHAR(32) PRIMARY KEY,
    assessment_type_id INT NOT NULL,
    test_taker_id CHAR(32),
    submission_time DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id),
    FOREIGN KEY (test_taker_id) REFERENCES Account(account_id)
);

CREATE TABLE TestType (
    test_type_id INT PRIMARY KEY,
    question_type_id INT NOT NULL,
    test_type_name VARCHAR(100) NOT NULL,
    num_questions INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (question_type_id) REFERENCES QuestionType(question_type_id)
);

CREATE TABLE Test (
    test_id CHAR(32) PRIMARY KEY,
    test_type_id INT NOT NULL,
    assessment_id CHAR(32),
    submission_time DATETIME,
    num_correct_answers INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (test_type_id) REFERENCES TestType(test_type_id),
    FOREIGN KEY (assessment_id) REFERENCES Assessment(assessment_id)
);

CREATE TABLE AssessmentTypeTestTypeMapping (
    assessment_type_id INT,
    test_type_id INT,
    PRIMARY KEY (assessment_type_id, test_type_id),
    FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id),
    FOREIGN KEY (test_type_id) REFERENCES TestType(test_type_id)
);


CREATE TABLE TestQuestion (
    test_question_id CHAR(32) PRIMARY KEY,
    test_id CHAR(32) NOT NULL,
    question_id INT NOT NULL,
    question_ordinal INT NOT NULL,
    answer_text VARCHAR(255),
    answer_audio_filepath VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (test_id) REFERENCES Test(test_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES Question(question_id) ON DELETE CASCADE
);

CREATE TABLE AutoGradingHistory (
    auto_grading_history_id CHAR(32) PRIMARY KEY,
    test_question_id CHAR(32) NOT NULL,
    model_name VARCHAR(255),
    auto_evaluation FLOAT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (test_question_id) REFERENCES TestQuestion(test_question_id) ON DELETE CASCADE
);

CREATE TABLE TeacherGradingHistory (
    teacher_grading_history_id CHAR(32) PRIMARY KEY,
    test_question_id CHAR(32) NOT NULL,
    teacher_account_id CHAR(32),
    teacher_evaluation BOOLEAN NOT NULL,
    teacher_comment VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (test_question_id) REFERENCES TestQuestion(test_question_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_account_id) REFERENCES Account(account_id)
);


INSERT INTO Account(account_id, account_role, first_name, last_name, email, username, hashed_password, current_enrolled_course) VALUES
    ('58973104203211ea8817bc2411ffed9d', 'student', 'Student', '1', 'student.1@gmail.com', 'student1', 'password1', 'Course 1'),
    ('7f8d6872203211ea8817bc2411ffed9d', 'teacher', 'Teacher', '1', 'teacher.1@gmail.com', 'teacher1', 'password1', NULL);

INSERT INTO QuestionType (question_type_id, question_type_name, question_instruction_text, instruction_audio_filepath) VALUES
    (1, 'Synthesis', 'I''ll say two sounds, you tell me the word, like this: "/m/ /oo/" - "moo".', 'questions/synthesis/instruction_synthesis.mp3'),
    (2, 'Analysis', 'I''ll say a syllable, and you tell me the three sounds you hear, like this: "boot" - "/b/ /oo/ /t/".', 'questions/analysis/instruction_analysis.mp3'),
    (3, 'Listening', 'I''ll say a syllable, and you tell me the middle vowel sound, like this: "boot" - "/oo/".', 'questions/listening/instruction_listening.mp3'),
    (4, 'Single Phoneme Recognition', 'Look at the sound card. Tell me the sound.', 'questions/single_phoneme_recognition/instruction_single_phoneme_recognition.mp3');

INSERT INTO Question(question_id, question_type_id, question_text, question_audio_filepath, correct_answer_audio_filepath) VALUES
    (101, 1, '/k/ /aw/', 'questions/synthesis/question_synthesis_k_aw.mp3', 'questions/synthesis/correct_answer_synthesis_k_aw.mp3'),
    (102, 1, '/t/ /o_e/', 'questions/synthesis/question_synthesis_t_o_e.mp3', 'questions/synthesis/correct_answer_synthesis_t_o_e.mp3'),
    (103, 1, '/t/ /a_e/', 'questions/synthesis/question_synthesis_t_a_e.mp3', 'questions/synthesis/correct_answer_synthesis_t_a_e.mp3'),
    (104, 1, '/sh/ /oo/', 'questions/synthesis/question_synthesis_sh_oo.mp3', 'questions/synthesis/correct_answer_synthesis_sh_oo.mp3'),
    (105, 1, '/f/ /ee/', 'questions/synthesis/question_synthesis_f_ee.mp3', 'questions/synthesis/correct_answer_synthesis_f_ee.mp3'),
    (106, 1, '/m/ /-a-/ /t/', 'questions/synthesis/question_synthesis_m_-a-_t.mp3', 'questions/synthesis/correct_answer_synthesis_m_-a-_t.mp3'),
    (107, 1, '/sh/ /oo/ /t/', 'questions/synthesis/question_synthesis_sh_oo_t.mp3', 'questions/synthesis/correct_answer_synthesis_sh_oo_t.mp3'),
    (108, 1, '/t/ /oy/ /m/', 'questions/synthesis/question_synthesis_t_oy_m.mp3', 'questions/synthesis/correct_answer_synthesis_t_oy_m.mp3'),
    (109, 1, '/s/ /oo/ /m/', 'questions/synthesis/question_synthesis_s_oo_m.mp3', 'questions/synthesis/correct_answer_synthesis_s_oo_m.mp3'),
    (110, 1, '/k/ /a_e/ /f/', 'questions/synthesis/question_synthesis_k_a_e_f.mp3', 'questions/synthesis/correct_answer_synthesis_k_a_e_f.mp3'),
    (111, 1, '/b/ /oy/', 'questions/synthesis/question_synthesis_b_oy.mp3', 'questions/synthesis/correct_answer_synthesis_b_oy.mp3'),
    (112, 1, '/l/ /i_e/', 'questions/synthesis/question_synthesis_l_i_e.mp3', 'questions/synthesis/correct_answer_synthesis_l_i_e.mp3'),
    (113, 1, '/r/ /o²o/', 'questions/synthesis/question_synthesis_r_o²o.mp3', 'questions/synthesis/correct_answer_synthesis_r_o²o.mp3'),
    (114, 1, '/d/ /oy/', 'questions/synthesis/question_synthesis_d_oy.mp3', 'questions/synthesis/correct_answer_synthesis_d_oy.mp3'),
    (115, 1, '/b/ /-a-/', 'questions/synthesis/question_synthesis_b_-a-.mp3', 'questions/synthesis/correct_answer_synthesis_b_-a-.mp3'),
    (116, 1, '/d/ /-o-/ /g/', 'questions/synthesis/question_synthesis_d_-o-_g.mp3', 'questions/synthesis/correct_answer_synthesis_d_-o-_g.mp3'),
    (117, 1, '/b/ /a_e/ /t/', 'questions/synthesis/question_synthesis_b_a_e_t.mp3', 'questions/synthesis/correct_answer_synthesis_b_a_e_t.mp3'),
    (118, 1, '/d/ /-a-/ /g/', 'questions/synthesis/question_synthesis_d_-a-_g.mp3', 'questions/synthesis/correct_answer_synthesis_d_-a-_g.mp3'),
    (119, 1, '/n/ /ar/ /g/', 'questions/synthesis/question_synthesis_n_ar_g.mp3', 'questions/synthesis/correct_answer_synthesis_n_ar_g.mp3'),
    (120, 1, '/s/ /-u-/ /d/', 'questions/synthesis/question_synthesis_s_-u-_d.mp3', 'questions/synthesis/correct_answer_synthesis_s_-u-_d.mp3'),
    (121, 1, '/b/ /-e-/ /p/', 'questions/synthesis/question_synthesis_b_-e-_p.mp3', 'questions/synthesis/correct_answer_synthesis_b_-e-_p.mp3'),
    (122, 1, '/l/ /-i-/ /n/', 'questions/synthesis/question_synthesis_l_-i-_n.mp3', 'questions/synthesis/correct_answer_synthesis_l_-i-_n.mp3'),
    (123, 1, '/v/ /-o-/ /d/', 'questions/synthesis/question_synthesis_v_-o-_d.mp3', 'questions/synthesis/correct_answer_synthesis_v_-o-_d.mp3'),
    (124, 1, '/ch/ /-u-/ /g/', 'questions/synthesis/question_synthesis_ch_-u-_g.mp3', 'questions/synthesis/correct_answer_synthesis_ch_-u-_g.mp3'),

    (201, 2, "mat", "questions/analysis/question_analysis_mat.mp3", 'questions/analysis/correct_answer_analysis_mat.mp3'),
    (202, 2, "shoot", "questions/analysis/question_analysis_shoot.mp3", 'questions/analysis/correct_answer_analysis_shoot.mp3'),
    (203, 2, "keep", "questions/analysis/question_analysis_keep.mp3", 'questions/analysis/correct_answer_analysis_keep.mp3'),
    (204, 2, "make", "questions/analysis/question_analysis_make.mp3", 'questions/analysis/correct_answer_analysis_make.mp3'),
    (205, 2, "pot", "questions/analysis/question_analysis_pot.mp3", 'questions/analysis/correct_answer_analysis_pot.mp3'),
    (206, 2, "poyt", "questions/analysis/question_analysis_poyt.mp3", 'questions/analysis/correct_answer_analysis_poyt.mp3'),
    (207, 2, "meef", "questions/analysis/question_analysis_meef.mp3", 'questions/analysis/correct_answer_analysis_meef.mp3'),
    (208, 2, "moosh", "questions/analysis/question_analysis_moosh.mp3", 'questions/analysis/correct_answer_analysis_moosh.mp3'),
    (209, 2, "tawf", "questions/analysis/question_analysis_tawf.mp3", 'questions/analysis/correct_answer_analysis_tawf.mp3'),
    (210, 2, "saf", "questions/analysis/question_analysis_saf.mp3", 'questions/analysis/correct_answer_analysis_saf.mp3'),
    (211, 2, "dog", "questions/analysis/question_analysis_dog.mp3", 'questions/analysis/correct_answer_analysis_dog.mp3'),
    (212, 2, "goal", "questions/analysis/question_analysis_goal.mp3", 'questions/analysis/correct_answer_analysis_goal.mp3'),
    (213, 2, "need", "questions/analysis/question_analysis_need.mp3", 'questions/analysis/correct_answer_analysis_need.mp3'),
    (214, 2, "bait", "questions/analysis/question_analysis_bait.mp3", 'questions/analysis/correct_answer_analysis_bait.mp3'),
    (215, 2, "job", "questions/analysis/question_analysis_job.mp3", 'questions/analysis/correct_answer_analysis_job.mp3'),
    (216, 2, "dag", "questions/analysis/question_analysis_dag.mp3", 'questions/analysis/correct_answer_analysis_dag.mp3'),
    (217, 2, "det", "questions/analysis/question_analysis_det.mp3", 'questions/analysis/correct_answer_analysis_det.mp3'),
    (218, 2, "narg", "questions/analysis/question_analysis_narg.mp3", 'questions/analysis/correct_answer_analysis_narg.mp3'),
    (219, 2, "jawd", "questions/analysis/question_analysis_jawd.mp3", 'questions/analysis/correct_answer_analysis_jawd.mp3'),
    (220, 2, "los", "questions/analysis/question_analysis_los.mp3", 'questions/analysis/correct_answer_analysis_los.mp3'),
    (221, 2, "ril", "questions/analysis/question_analysis_ril.mp3", 'questions/analysis/correct_answer_analysis_ril.mp3'),
    (222, 2, "dov", "questions/analysis/question_analysis_dov.mp3", 'questions/analysis/correct_answer_analysis_dov.mp3'),
    (223, 2, "leb", "questions/analysis/question_analysis_leb.mp3", 'questions/analysis/correct_answer_analysis_leb.mp3'),
    (224, 2, "nach", "questions/analysis/question_analysis_nach.mp3", 'questions/analysis/correct_answer_analysis_nach.mp3'),

    (301, 3, "peef", "questions/listening/question_listening_peef.mp3", 'questions/listening/correct_answer_listening_peef.mp3'),
    (302, 3, "soot", "questions/listening/question_listening_soot.mp3", 'questions/listening/correct_answer_listening_soot.mp3'),
    (303, 3, "mawsh", "questions/listening/question_listening_mawsh.mp3", 'questions/listening/correct_answer_listening_mawsh.mp3'),
    (304, 3, "hoym", "questions/listening/question_listening_hoym.mp3", 'questions/listening/correct_answer_listening_hoym.mp3'),
    (305, 3, "shate", "questions/listening/question_listening_shate.mp3", 'questions/listening/correct_answer_listening_shate.mp3'),
    (306, 3, "fash", "questions/listening/question_listening_fash.mp3", 'questions/listening/correct_answer_listening_fash.mp3'),
    (307, 3, "mote", "questions/listening/question_listening_mote.mp3", 'questions/listening/correct_answer_listening_mote.mp3'),
    (308, 3, "dus", "questions/listening/question_listening_dus.mp3", 'questions/listening/correct_answer_listening_dus.mp3'),
    (309, 3, "gown", "questions/listening/question_listening_gown.mp3", 'questions/listening/correct_answer_listening_gown.mp3'),
    (310, 3, "bif", "questions/listening/question_listening_bif.mp3", 'questions/listening/correct_answer_listening_bif.mp3'),
    (311, 3, "chem", "questions/listening/question_listening_chem.mp3", 'questions/listening/correct_answer_listening_chem.mp3'),
    (312, 3, "do²ok", "questions/listening/question_listening_do²ok.mp3", 'questions/listening/correct_answer_listening_do²ok.mp3'),
    (313, 3, "shike", "questions/listening/question_listening_shike.mp3", 'questions/listening/correct_answer_listening_shike.mp3'),
    (314, 3, "tharm", "questions/listening/question_listening_tharm.mp3", 'questions/listening/correct_answer_listening_tharm.mp3'),
    (315, 3, "fume", "questions/listening/question_listening_fume.mp3", 'questions/listening/correct_answer_listening_fume.mp3'),
    (316, 3, "sert", "questions/listening/question_listening_sert.mp3", 'questions/listening/correct_answer_listening_sert.mp3'),
    (317, 3, "baft", "questions/listening/question_listening_baft.mp3", 'questions/listening/correct_answer_listening_baft.mp3'),
    (318, 3, "spish", "questions/listening/question_listening_spish.mp3", 'questions/listening/correct_answer_listening_spish.mp3'),
    (319, 3, "def", "questions/listening/question_listening_def.mp3", 'questions/listening/correct_answer_listening_def.mp3'),
    (320, 3, "rimp", "questions/listening/question_listening_rimp.mp3", 'questions/listening/correct_answer_listening_rimp.mp3'),

    (401, 4, "f", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_f.mp3"),
    (402, 4, "th", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_th.mp3"),
    (403, 4, "sh", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_sh.mp3"),
    (404, 4, "s", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_s.mp3"),
    (405, 4, "m", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_m.mp3"),
    (406, 4, "p", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_p.mp3"),
    (407, 4, "t", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_t.mp3"),
    (408, 4, "k", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_k.mp3"),
    (409, 4, "h", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_h.mp3"),
    (410, 4, "ch", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_ch.mp3"),
    (411, 4, "b", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_b.mp3"),
    (412, 4, "d", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_d.mp3"),
    (413, 4, "g", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_g.mp3"),
    (414, 4, "w(wh)", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_w(wh).mp3"),
    (415, 4, "t²h", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_t²h.mp3"),
    (416, 4, "n", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_n.mp3"),
    (417, 4, "v", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_v.mp3"),
    (418, 4, "l", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_l.mp3"),
    (419, 4, "r", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_r.mp3"),
    (420, 4, "j", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_j.mp3"),
    (421, 4, "z", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_z.mp3"),
    (422, 4, "x", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_x.mp3"),
    (423, 4, "qu", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_qu.mp3"),
    (424, 4, "y", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_y.mp3"),
    (425, 4, "c", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_c.mp3"),
    (426, 4, "_ng", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_ng.mp3"),

    (427, 4, "ee", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_ee.mp3"),
    (428, 4, "oo", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_oo.mp3"),
    (429, 4, "aw", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_aw.mp3"),
    (430, 4, "oy", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_oy.mp3"),
    (431, 4, "a_e", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_a_e.mp3"),
    (432, 4, "ow", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_ow.mp3"),
    (433, 4, "o_e", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_o_e.mp3"),
    (434, 4, "-u-", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_-u-.mp3"),
    (435, 4, "-o-", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_-o-.mp3"),
    (436, 4, "-a-", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_-a-.mp3"),
    (437, 4, "-i-", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_-i-.mp3"),
    (438, 4, "-e-", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_-e-.mp3"),
    (439, 4, "ar", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_ar.mp3"),
    (440, 4, "o²o", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_o²o.mp3"),
    (441, 4, "i_e", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_i_e.mp3"),
    (442, 4, "u_e", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_u_e.mp3"),
    (443, 4, "or", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_or.mp3"),
    (444, 4, "er", NULL, "questions/single_phoneme_recognition/correct_answer_single_phoneme_recognition_er.mp3");

INSERT INTO AssessmentType(assessment_type_id, assessment_type_name) VALUES
    (1, 'Phonological Skills Assessmen');

INSERT INTO TestType(test_type_id, question_type_id, test_type_name, num_questions) VALUES
    (1, 1, 'Synthesis', 5),
    (2, 2, 'Analysis', 5),
    (3, 3, 'Listening', 5),
    (4, 4, 'Single Phoneme Recognition', 5);

INSERT INTO AssessmentTypeTestTypeMapping(assessment_type_id, test_type_id) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4);