Table of Contents

-   [GET /api/test_types](#get-apitest_types)
-   [POST /api/tests](#post-apitests)
-   [PUT /api/tests/{test_id}](#put-apiteststest_id)

## GET /api/test_types

Called when first load the page.

### Response

```json
Status: 200 OK

{
    "test_types": [
        {
            "test_type_id": "test_type_id",
            "question_type_id": "question_type_id",
            "name": "test_type_name",
            "num_questions": "num_questions"
        }
    ]
}
```

## POST /api/tests

Called when user start taking a test (click on a test in the test list).

### Request

```json
{
    "test_type_id": "test_type_id (integer)",
    "account_id": "account_id (UUID)"
}
```

In the final app, the `account_id` will be the logged in user's account id. For now:

-   if the `account_id` actually exists in the database, the test will be created for that account.
-   if the `account_id` does not exist in the database, the test will be created for the first student account.

### Response

```json
Status: 201 Created

{
    "test_id": "test_id",
    "test_type_id": "test_type_id",
    "test_taker_id": "account_id",
    "instruction_text": "instruction_text",
    "instruction_audio": "instruction_audio_file_b64_encode",
    "test_questions": [
        {
            "test_question_id": "test_question_id",
            "question": {
                "question_id": "question_id",
                "question_type": {
                    "question_type_id": "question_type_id",
                    "name": "question_type_name"
                },
                "question_text": "question_text",
                "question_audio": "question_audio_file_b64_encode"
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

## PUT /api/tests/{test_id}

Called when user submit a test.

In the final app, authenication (e.g.: token) will be required to make this request.

### Request

```json
{
    "test_questions": [
        {
            "test_question_id": "test_question_id",
            "answer_text": "answer_text",
            "answer_audio": "answer_audio_file_b64_encode"
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
