Table of Contents

-   [GET /api/test_types](#get-apitest_types)
-   [POST /api/tests](#post-apitests)
-   [PUT /api/tests/{test_id:uuid}](#put-api-tests-test_id-uuid)

## GET /api/test_types

Called when first load the page.

### Response

```json
Status: 200 OK

{
    "test_types": [
        {
            "test_type_id": 1,
            "question_type_id": 1,
            "name": "Synthesis",
            "num_questions": 20,
        }
    ]
}
```

## POST /api/tests

Called when user start taking a test (click on a test in the test list).

### Request

```json
{
    "test_type_id": "1",
    "test_taker_id": "58973104203211ea8817bc2411ffed9d"
}
```

In the final app, the `account_id` will be the logged in user's account id. For now:

-   if the `account_id` actually exists in the database, the test will be created for that account.
-   if the `account_id` does not exist in the database, the test will be created for the first student account.

### Response

```json
Status: 201 Created

{
    "test_id": "uuid (no hyphens)",
    "test_type": {
        "test_type_id": 1,
        "name": "Synthesis",
        "num_questions": 20,
    },
    "test_taker_id": "58973104203211ea8817bc2411ffed9d",
    "instruction_text": "I'll say two sounds, you tell me the word.",
    "instruction_audio_b64_encode": "string",
    "test_questions": [
        {
            "test_question_id": "uuid (no hyphens)",
            "question": {
                "question_id": "uuid (no hyphens)",
                "question_type": {
                    "question_type_id": 1,
                    "name": "Synthesis",
                },
                "question_text": "/k/ /aw/",
                "question_audio_b64_encode": "string"
            }
        }
    ]
}
```

```json
Status: 400 Bad Request

{
    "error": "account_id is required"
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
            "test_question_id": "uuid (no hyphens)",
            "answer_text": "string",
            "answer_audio_b64_encode": "string"
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
    "error": "test_question_id is required"
}
```

```json
Status: 404 Not Found

{
    "error": "test_question_id does not exist"
}
```

```json
Status: 400 Bad Request

{
    "error": "answer_text or answer_audio is required"
}
```
