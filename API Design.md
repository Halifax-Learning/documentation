### Table of Contents

-   [User APIs](#user-apis)
    -   [POST /api/register](#post-apiregister)
    -   [POST /api/login](#post-apilogin)
    -   [Response for missing or invalid token](#response-for-missing-or-invalid-token)
-   [Assessment APIs](#assessment-apis)
    -   [GET /api/assessment_types](#get-apiassessment_types)
    -   [GET /api/assessments](#get-apiassessments)
    -   [GET /api/assessments/{assessment_id}](#get-apiassessmentsassessment_id)
    -   [GET /api/in_progress_assessment](#get-apiin_progress_assessment)
    -   [POST /api/assessments](#post-apiassessments)
    -   [PUT /api/test_questions/{test_question_id}](#put-apitest_questionstest_question_id)
    -   [POST /api/teacher_grading_history](#post-apiteacher_grading_history)
-   [Audio APIs](#audio-apis)
    -   [GET /api/audio/<test_id>](#get-apiaudiotest_id)
    -   [GET /api/audio/?audio_type=question&question_id=1](#get-apiaudioaudio_typequestionquestion_id1) (DEPRECATED)

# User APIs

## POST /api/register

Called when a user registers for an account. Will create an `Account` record in the database. Password will be hashed before saving to the database.

Only create Student accounts for now. In the final app, we may only allow teacher accounts to be created by invitation links.

### Request

```json
{
    "first_name": "John",
    "last_name": "Doe",
    "email": "student.2@gmail.com",
    "password": "pass"
}
```

### Response

```json
Status: 201 Created

{
  "account_id": "ea200063-496c-476a-9dae-2eb711862146",
  "account_role": "student",
  "first_name": "John",
  "last_name": "Doe",
  "email": "student.2@gmail.com",
  "current_enrolled_course": null,
  "token": "string"
}
```

```json
Status: 400 Bad Request

{
    "error": "Missing required body parameters."
}
```

```json
Status: 400 Bad Request

{
    "error": "Email already in use."
}
```

## POST /api/login

Called when a user logs in. Will return the user's information.

### Request

```json
{
    "email": "student.2@gmail.com",
    "password": "pass"
}
```

### Response

```json
Status: 200 OK

{
  "account_id": "ea200063-496c-476a-9dae-2eb711862146",
  "account_role": "student",
  "first_name": "John",
  "last_name": "Doe",
  "email": "student.2@gmail.com",
  "current_enrolled_course": null,
  "token": "string"
}
```

```json
Status: 400 Bad Request

{
    "error": "Missing required body parameters."
}
```

```json
Status: 401 Unauthorized

{
    "error": "Wrong email or password."
}
```

## Response for missing or invalid token

For all requests except register and login, if the token is missing or invalid, the server will return a 401 Unauthorized status code.

```json
Status: 401 Unauthorized

{
    "error": "No token provided."
}
```

```json
Status: 401 Unauthorized

{
    "error": "Invalid token."
}
```

# Assessment APIs

## GET /api/assessment_types

Called when the web app is first loaded. Will return a list of assessment types that the user can take. Technically, there is only one type of assessment in the database right now.

### Request

```http
Authorization: Bearer <token>
```

### Response

```json
Status: 200 OK

{
    "assessment_types": [
        {
            "assessment_type_id": 1,
            "assessment_type_name": "Phonological Skills Assessment"
        }
    ]
}
```

## GET /api/assessments

For teacher, return a list of assessments. For student, return a list of assessments taken by the student.

### Request

```http
Authorization: Bearer <token>
```

### Response

```json
Status: 200 OK

{
    "assessments": [
        {
            "assessment_id": "uuid",
            "assessment_type": {
                "assessment_type_id": 1,
                "assessment_type_name": "Phonological Skills Assessment"
            },
            "test_taker": {
                "account_id": "uuid",
                "account_role": "student",
                "first_name": "John",
                "last_name": "Doe",
                "email": "student.2@gmail.com",
                "current_enrolled_course": null
            },
            "assessment_submission_time": "2020-02-02T02:02:02Z",
            "is_all_tests_graded_by_teacher": false,
            "tests": [
                {
                "test_id": "4b53a8b5-bb01-401f-a247-27964c876238",
                "test_type_id": 1,
                "assessment_id": "13f2a101-2268-4219-8f25-a4d45113224f",
                "test_ordinal": 1,
                "is_last_test": false,
                "test_submission_time": "2020-02-02T02:02:02Z",
                "auto_score": null,
                "teacher_score": null
            },
            ]
        }
    ]
}
```

## GET /api/assessments/{assessment_id}

For **teacher only**. Get a `Assessment` record and associated `Test` records and `TestQuestion` records in the database for teacher evaluation.

**Note**: We don't send the audio filepaths directly in the response because we don't want to expose the file structure of the server. Instead, we set the property `has_question_audio` to `true` or `false` to indicate whether question audio files exist for a test. Similarly, we set the property `has_correct_answer_audio` to indicate whether correct answer audio files exist for a test and `has_answer_audio` to indicate whether answer audio files exist for a test question.
We will use the `GET /api/audio/<test_id>` endpoint to get the audio files.

### Request

```http
Authorization: Bearer <token>
```

### Response

```json
Status: 200 OK

{
    "assessment_id": "uuid",
    "assessment_type": {
        "assessment_type_id": 1,
        "assessment_name": "Phonological Skills Assessment"
    },
    "test_taker": {
        "account_id": "uuid",
        "account_role": "student",
        "first_name": "John",
        "last_name": "Doe",
        "email": "student.2@gmail.com",
        "current_enrolled_course": null
    },
    "assessment_submission_time": "2020-02-02T02:02:02Z",
    "is_all_tests_graded_by_teacher": false,
    "tests": [
        {
            "test_id": "uuid",
            "test_type": {
                "test_type_id": 1,
                "question_type": {
                    "question_type_id": 1,
                    "question_type_name": "Synthesis",
                    "question_instruction_text": "I'll say two sounds, you tell me the word."
                },
                "test_type_name": "Synthesis",
                "num_questions": 20,
                "has_question_audio": true,
                "has_correct_answer_audio": true
            },
            "test_ordinal": 1,
            "is_last_test": false,
            "test_submission_time": "2020-02-02T02:02:02Z",
            "auto_score": null,
            "teacher_score": null,
            "test_questions": [
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 101,
                        "question_text": "/k/ /aw/",
                    },
                    "question_ordinal": 1,
                    "is_last_question": false,
                    "answer_text": null,
                    "has_answer_audio": true,
                    "latest_auto_evaluation": null,
                    "latest_teacher_evaluation": null,
                    "test_question_submission_time": "2020-02-02T02:02:02Z",
                    "auto_grading_history": [
                        {
                            "auto_grading_history_id": "uuid",
                            "model_name": "string",
                            "auto_evaluation": 90,
                            "created_at": "2020-02-02T02:02:02Z"
                        }
                    ],
                    "teacher_grading_history": [
                        {
                            "teacher_grading_history_id": "uuid",
                            "teacher_account_id": "uuid",
                            "teacher_evaluation": true,
                            "teacher_comment": "string",
                            "created_at": "2020-02-02T02:02:02Z"
                        }
                    ]
                }
            ]
        },
    ]
}
```

```json
Status: 404 Not Found

{
    "error": "Assessment not found."
}
```

## GET /api/in_progress_assessment

Get the assessment that is currently in progress, if any.

### Request

```http
Authorization: Bearer <token>
```

### Response

```json
Status: 200 OK

{
    "assessment_id": "uuid",
    "assessment_type": {
        "assessment_type_id": 1,
        "assessment_name": "Phonological Skills Assessment"
    },
    "tests": [
        {
            "test_id": "uuid",
            "test_type": {
                "test_type_id": 1,
                "question_type": {
                    "question_type_id": 1,
                    "question_type_name": "Synthesis",
                    "question_instruction_text": "I'll say two sounds, you tell me the word."
                },
                "test_type_name": "Synthesis",
                "num_questions": 20,
                "has_question_audio": true
            },
            "test_ordinal": 1,
            "is_last_test": false,
            "test_submission_time": null,
            "test_questions": [
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 101,
                        "question_text": "/k/ /aw/",
                    },
                    "question_ordinal": 1,
                    "is_last_question": false,
                    "test_question_submission_time": null
                },
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 102,
                        "question_text": "/t/ /o_e/",
                    },
                    "question_ordinal": 2,
                    "is_last_question": true,
                    "test_question_submission_time": null
                }
            ]
        },
        {
            "test_id": "uuid",
            "test_type": {
                "test_type_id": 2,
                "question_type": {
                    "question_type_id": 2,
                    "question_type_name": "Analysis",
                    "question_instruction_text": "I'll say a word, you tell me the sounds."
                },
                "test_type_name": "Analysis",
                "num_questions": 20
            },
            "test_ordinal": 2,
            "is_last_test": true,
            "test_submission_time": null,
            "test_questions": [
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 201,
                        "question_text": "cat",
                    },
                    "question_ordinal": 1,
                    "is_last_question": false,
                    "test_question_submission_time": null
                },
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 202,
                        "question_text": "dog",
                    },
                    "question_ordinal": 2,
                    "is_last_question": true,
                    "test_question_submission_time": null
                }
            ]
        }
    ]
}
```

```json
Status: 204 No Content
```

## POST /api/assessments

Called when a student starts an assessment. Will create a `Assessment` record and associated `Test` records and `TestQuestion` records in the database.

### Request

```json
Authorization: Bearer <token>

{
    "assessment_type_id": 1
}
```

### Response

```json
Status: 201 Created
```

The success response body will be the same as the response of `GET /api/in_progress_assessment`, except there will be no `test_submission_time` and `test_question_submission_time` fields.

```json
Status: 403 Forbidden

{
    "error": "An assessment is currently in progress."
}
```

```json
Status: 400 Bad Request

{
    "error": "Missing required body parameters: assessment_type_id."
}
```

```json
Status: 404 Not Found

{
    "error": "Assessment Type not found."
}
```

```json
Status: 500 Internal Server Error

{
    "error": "Failed to create assessment."
}
```

## PUT /api/test_questions/{test_question_id}

Called when a student click "Next" button to go to the next question, then the answer to the current question will be saved. If the question (`TestQuestion`) is the last question of a test, the `Test` record's `test_submission_time` will be updated. If the test is the last test of a assessment, the `Assessment` record's `assessment_submission_time` will be updated.

### Request

```json
Authorization: Bearer <token>

{
    "answer_text": "string",
    "answer_audio": "<binary data>"
}
```

### Response

```json
Status: 200 OK
```

```json
Status: 403 Forbidden

{
    "error": "Request sender is not the test taker."
}

```

```json
Status: 404 Not Found

{
    "error": "Test Question not found."
}
```

```json
Status: 403 Forbidden

{
    "error": "Test question has already been submitted."
}
```

```json
Status: 404 Not Found

{
    "error": "The test question is not associated with any test."
}
```

```json
Status: 404 Not Found

{
    "error": "The test question is not associated with any assessment."
}
```

```json
Status: 500 Internal Server Error

{
    "error": "Failed to save the audio file to the file system."
}
```

```json
Status: 500 Internal Server Error

{
    "error": "Failed to save data to the database."
}
```

## POST /api/teacher_grading_history

Called when a teacher clicks the "Save" button in the grading screen.

### Request

```json
Authorization: Bearer <token>

{
    "teacher_account_id": "uuid",
    "test_questions": [
        {
            "test_question_id": "uuid",
            "teacher_evaluation": true,
            "teacher_comment": "string"
        },
        {
            "test_question_id": "uuid",
            "teacher_evaluation": false,
            "teacher_comment": "string"
        }
    ]
}
```

### Response

```json
Status: 201 Created
```

```json
Status: 403 Forbidden

{
    "error": "Request sender is not a teacher."
}
```

```json
Status: 400 Bad Request

{
    "error": "Missing required body parameters: teacher_evaluation | test_question_id."
}
```

```json
Status: 400 Bad Request

{
    "error": "Invalid body parameters: teacher_evaluation."
}
```

```json
Status: 400 Bad Request

{
    "error": "Duplicate test question id in request data."
}
```

```json
Status: 404 Not Found

{
    "error": "Test Question not found."
}
```

```json
Status: 403 Forbidden

{
    "error": "Some test question has not been submitted."
}
```

```json
Status: 500 Internal Server Error

{
    "error": "Failed to save data to the database."
}
```

# Audio APIs

## GET /api/audio/<test_id>

Get all instruction, question, correct answer and student answer audios from a Test instance and return them as a zip file.

### Request

```http
Authorization: Bearer <token>
```

### Response

```http
Status: 200 OK

Content-Type: application/zip

Content-Disposition: attachment; filename="test_<test_id>_audios.zip"
```

## GET /api/audio/?audio_type=question&question_id=1

DEPRECATED: This endpoint is deprecated and is not used.

Possible parameter combinations:

```
-   audio_type=instruction & id={question_type_id}

-   audio_type=question & id={question_id}

-   audio_type=correct_answer & id={question_id}

-   audio_type=answer & id={test_question_id}
```

### Response

```http
Status: 200 OK

Content-Type: audio/mp3

<binary data>
```

```json
Status: 400 Bad Request

{
    "error": "Missing required parameters: audio_type, id."
}
```

```json
Status: 400 Bad Request

{
    "error": "Invalid parameters: audio_type."
}
```

```json
Status: 404 Not Found

{
    "error": "Question Type not found."
}
```

```json
Status: 404 Not Found

{
    "error": "Question not found."
}
```

```json
Status: 404 Not Found

{
    "error": "Test Question not found."
}
```

```json
Status: 404 Not Found

{
    "error": "Audio File not found."
}
```
