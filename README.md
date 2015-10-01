# yesorno-web

API for yes/no app built for hackathon. 

## Misc

#####  Post Headers

`Content-Type: application/x-www-form-urlencoded`

#####  Auth Token

`?user_token='<token>'`
## Authentication

`POST /api/register` will register a new user with the following: 

* user[email]
* user[password]
* user[password_confirmation]

`DELETE /api/logout` will log a user out

`POST /api/login` will log a user in, when provided with: 

* user[email] 
* user[password]

This will return a `201 Created` and return the following: 

    {
        "message": "Logged in",
        "auth_token": "wKHeAzcYm7LmPNh-k-vM"
    }


## Asking Questions
`GET /api/questions` returns lists of all questions

`GET /api/my_questions` returns lists of all questions the logged in user has asked

`GET /api/questions/1` returns question w/id 1 

    {[ "results": 
        "id": 31,
        "content": "Are all apples red?",
        "user": {
            "id": 11,
            "username": "Derek"
        }, 
        "question_image": "/path_to_image",
        "responses": [{
            "id": 7,
            "is_yes": true,
            "created_at": "2015-05-17T12:48:35.272Z",
            "updated_at": "2015-05-17T12:48:35.272Z",
            "user": {
                "id": 10,
                "username": "denise"}
             }]
    }]



`POST /api/questions/` adds a new question

    { "status": "success" }

This will return a `201 Created`. There is an option to also include an image: 

    * question[question_image][content] 
    * question[question_image][filename]
    * question[question_image][content_type]
    * question[content]
 
## Adding Responses

`POST /api/questions/1/responses` add a new response to question 1
This will return a `201 Created` and the response the user submitted as a JSON object. 

`GET /questions/1/responses` returns lists of all responses to question with id 1

    { "results": [
        {
            "id": 7,
            "is_yes": true,
            "created_at": "2015-05-17T12:48:35.272Z",
            "updated_at": "2015-05-17T12:48:35.272Z",
            "user": {
                "id": 10,
                "username": "denise"
            }
        },
        {
            "id": 8,
            "is_yes": true,
            "created_at": "2015-05-17T12:50:44.600Z",
            "updated_at": "2015-05-17T12:50:44.600Z",
            "user": {
                "id": 11,
                "username": "Derek"
            }
        },
        {
            "id": 9,
            "is_yes": false,
            "created_at": "2015-05-17T12:50:59.970Z",
            "updated_at": "2015-05-17T12:50:59.970Z",
            "user": {
                "id": 11,
                "username": "Derek"
            }
        }
    }

`GET /api/questions/1/statistics` returns yes & no counts of the responses 
    
    { "yes": 2, "no": 1 } 
