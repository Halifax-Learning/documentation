### Table of Contents

-   [User APIs](#user-apis)
    -   [POST /api/register](#post-apiregister)
    -   [POST /api/login](#post-apilogin)
-   [Taking an Assessment APIs](#taking-an-assessment-apis)
    -   [GET /api/assessment_types](#get-apiassessment_types)
    -   [POST /api/assessments](#post-apiassessments)
    -   [POST /api/tests](#post-apitests)
    -   [PUT /api/tests/{test_id:uuid}](#put-api-tests-test_id-uuid)

# User APIs

## POST /api/register

Called when a user registers for an account. Will create an `Account` record in the database. Password will be hashed before saving to the database.

Only create Student accounts for now. In the final app, we may only allow teacher accounts to be created by invitation links.

Response only includes user information without password. In the final app, we may want to return a token for the user to use for authentication (same for login).

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

# Taking an Assessment APIs

## POST /api/assessments

Called when a student starts an assessment (aka a group of tests). Will create a `Assessment` record in the database and return a list of test types associated with the test group type.

### Request

```json
{
    "assessment_type_id": 1,
    "test_taker_id": "58973104203211ea8817bc2411ffed9d"
}
```

In the final app, the `account_id` will be the logged in user's account id. For now:

-   if the `account_id` actually exists in the database, a `TestGroup` record will be created for that account.
-   if the `account_id` does not exist in the database, a `TestGroup` record will be created for the first student account in the database.

### Response

```json
Status: 200 OK

{
    "assessment_id": "uuid",
    "assessment_type": {
        "assessment_type_id": 1,
        "assessment_name": "Phonological Skills Assessment"
    },
    "test_types": [
        {
            "test_type_id": 1,
            "question_type_id": 1,
            "question_type_name": "Synthesis",
            "num_questions": 20,
            "question_instruction_text": "I'll say two sounds, you tell me the word, like this: \"/m/ /oo/\" - \"moo\"."
        },
        {
            "test_type_id": 2,
            "question_type_id": 2,
            "question_type_name": "Analysis",
            "num_questions": 20,
            "question_instruction_text": "I'll say a syllable, and you tell me the three sounds you hear, like this: \"boot\" - \"/b/ /oo/ /t/\"."
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

## POST /api/tests

Called when user starts taking a test in a test group. Will create a `Test` record and associated `TestQuestion` records in the database.

### Request

```json
{
    "assessment_id": "uuid",
    "test_type_id": 1
}
```

### Response

```json
Status: 201 Created

{
    "test_id": "uuid",
    "test_type": {
        "test_type_id": 1,
        "name": "Synthesis",
        "num_questions": 20
    },
    "assessment_id": "uuid",
    "question_instruction_text": "I'll say two sounds, you tell me the word.",
    "instruction_audio_b64_encode": "string",
    "test_questions": [
        {
            "test_question_id": "uuid",
            "question": {
                "question_id": 101,
                "question_type": {
                    "question_type_id": 1,
                    "question_type_name": "Synthesis"
                },
                "question_text": "/k/ /aw/",
                "question_audio_b64_encode": "string"
            },
            "question_ordinal": 1
        }
    ]
}
```

```json
Status: 400 Bad Request

{
    "error": "assessment_id is required"
}
```

```json
Status: 404 Not Found

{
    "error": "assessment_id does not exist"
}
```

```json
Status: 400 Bad Request

{
    "error": "test_type_id is required"
}
```

```json
Status: 404 Not Found

{
    "error": "test_type_id does not exist"
}
```

```json
Status: 400 Bad Request

{
    "error": "test already exists"
}
```

## PUT /api/tests/{test_id:uuid}<a id="put-api-tests-test_id-uuid"></a>

**Note**:

-   Maybe we want both teacher when grading a test and student when submitting a test to use this API.
-   For student, we should only allow this API to be called once per test.

Called when user submit a test.

In the final app, authenication (e.g.: token) will be required to make this request.

### Request

```json
{
    "test_questions": [
        {
            "test_question_id": "uuid",
            "answer_text": "string",
            "answer_audio_b64_encode": "UklGRiQAAABXQVZFZm10IBAAAAABAAEAESsAACJWAAACABAAZGF0YQAAAAA"
        }
    ]
}
```

### Response

```json
Status: 200 OK
```

```json
Status: 404 Not Found

{
    "error": "test_id does not exist"
}
```

```json
Status: 400 Bad Request

{
    "error": "test has already been submitted"
}
```

```json
Status: 400 Bad Request

{
    "error": "test_question_id is required"
}
```

```json
Status: 404 Not Found

{
    "error": "test_question_id does not exist"
}
```

```

```
