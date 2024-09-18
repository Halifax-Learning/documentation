### Table of Contents

-   [User APIs](#user-apis)
    -   [POST /api/register](#post-apiregister)
    -   [POST /api/login](#post-apilogin)
-   [Assessment APIs](#assessment-apis)
    -   [GET /api/assessment_types](#get-apiassessment_types)
    -   [POST /api/assessments](#post-apiassessments)
    -   [PUT /api/test_questions/{test_question_id}](#put-apitest_questionstest_question_id)
-   [Audio APIs](#audio-apis)
    -   [GET /api/audio/?audio_type=question&question_id=1](#get-apiaudioaudio_typequestionquestion_id1)

# User APIs

## POST /api/register

Called when a user registers for an account. Will create an `Account` record in the database. Password will be hashed before saving to the database.

Only create Student accounts for now. In the final app, we may only allow teacher accounts to be created by invitation links.

Response only includes user information without password. In the final app, we may want to return a token for the user to use for authentication (same for login). Token will also contain the user's role.

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
  "current_enrolled_course": null
}
```

```json
Status: 400 Bad Request

{
    "error": "missing required fields"
}
```

```json
Status: 400 Bad Request

{
    "error": "email already exists"
}
```

## POST /api/login

Called when a user logs in. Will return the user's information.

In the final app, we may want to return a token for the user to use for authentication.

Should we have separate error messages for incorrect email and incorrect password?

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
  "current_enrolled_course": null
}
```

```json
Status: 400 Bad Request

{
    "error": "missing required fields"
}
```

```json
Status: 404 Not Found

{
    "error": "email does not exist"
}
```

```json
Status: 401 Unauthorized

{
    "error": "incorrect password"
}
```

# Assessment APIs

## GET /api/assessment_types

Called when the web app is first loaded. Will return a list of assessment types that the user can take. Technically, there is only one type of assessment in the database right now.

### Response

```json
Status: 200 OK

{
    "assessment_types": [
        {
            "assessment_type_id": 1,
            "assessment_name": "Phonological Skills Assessment"
        }
    ]
}
```

## POST /api/assessments

Called when a student starts an assessment (aka a group of tests). Will create a `Assessment` record and associated `Test` records and `TestQuestion` records in the database.

### Request

```json
{
    "assessment_type_id": 1,
    "test_taker_id": "58973104203211ea8817bc2411ffed9d"
}
```

In the final app, a token will be sent in the header to authenticate the user. For now we use the `test_taker_id` in the request body to identify the user.

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
            "test_questions": [
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 101,
                        "question_text": "/k/ /aw/",
                    },
                    "question_ordinal": 1,
                    "is_last_question": false
                },
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 102,
                        "question_text": "/t/ /o_e/",
                    },
                    "question_ordinal": 2,
                    "is_last_question": true
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
            "test_questions": [
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 201,
                        "question_text": "cat",
                    },
                    "question_ordinal": 1,
                    "is_last_question": false
                },
                {
                    "test_question_id": "uuid",
                    "question": {
                        "question_id": 202,
                        "question_text": "dog",
                    },
                    "question_ordinal": 2,
                    "is_last_question": true
                }
            ]
        }
    ]
}
```

```json
Status: 400 Bad Request

{
    "error": "assessment_type_id is required"
}
```

```json
Status: 404 Not Found

{
    "error": "assessment_type_id does not exist"
}
```

```json
Status: 400 Bad Request

{
    "error": "test_taker_id is required"
}
```

```json
Status: 404 Not Found

{
    "error": "test_taker_id does not exist"
}
```

## PUT /api/test_questions/{test_question_id}

Called when a student click "Next" button to go to the next question, then the answer to the current question will be saved.

### Request

```json
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
Status: 404 Not Found

{
    "error": "Test question not found."
}
```

```json
Status: 400 Bad Request

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

# Audio APIs

## GET /api/audio/?audio_type=question&question_id=1

Possible parameter combinations:

```
- audio_type=instruction & id={question_type_id}

- audio_type=question & id={question_id}

- audio_type=correct_answer & id={question_id}

- audio_type=answer & id={test_question_id}
```

### Response

```
Status: 200 OK

Content-Type: audio/mp3

<binary data>
```

```json
Status: 400 Bad Request

{
    "error": "Missing required parameters."
}
```

```json
Status: 400 Bad Request

{
    "error": "Invalid parameters."
}
```

```json
Status: 404 Not Found

{
    "error": "Question type not found."
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
    "error": "Test question not found."
}
```

```json
Status: 404 Not Found

{
    "error": "Audio file not found."
}
```
