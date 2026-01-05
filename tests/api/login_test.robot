*** Settings ***
Documentation    API tests for user authentication and token handling
Library        RequestsLibrary
Library        Collections
Resource       ../resources/api/auth_keywords.resource   
Resource       ../resources/api/categories_keywords.resource
*** Variables ***

${USERNAME}    %{API_USERNAME}
${PASSWORD}    %{API_PASSWORD}


*** Test Cases ***
Login Succeeds And Returns Tokens
    [Documentation]    Validates successful login and ensures both access and refresh tokens are returned.
    [Tags]    api    auth    smoke    tokens
    ${access_token}    ${refresh_token}=    Login And Get Tokens
    Should Not Be Empty    ${access_token}
    Should Contain    ${access_token}    .
    Should Not Be Empty    ${refresh_token}
    Should Contain    ${refresh_token}    .
    Log    ${access_token}
    Log    ${refresh_token}login_test.robot tiedostoon

Refresh Token Succeeds And Returns Token
    [Documentation]    Post refresh token and return  valid accesstoken
    [Tags]    api    auth    smoke    refresh
    ${access_token}    ${refresh_token}=    Login And Get Tokens
    Should Not Be Empty    ${access_token}
    Should Contain    ${access_token}    .
    Should Not Be Empty    ${refresh_token}
    Should Contain    ${refresh_token}    .
    ${new_access_token}=    Login And Get Refresh Token    ${access_token}    ${refresh_token}
    Should Not Be Empty    ${access_token}
    Should Not Be Equal    ${access_token}    ${new_access_token}
    
Unauthorized Request With Invalid Access Token
    [Documentation]    Verifies that protected endpoint returns 401 when access token is invalid.
    [Tags]    api    auth    security    unauthorized        
    VAR    ${invalid_token}    invalid 
    Create Session    api_auth_invalid_token    ${BASE_URL}    headers={"Authorization":"Bearer ${invalid_token}","Content-Type":"application/json"}
    ${response}=    GET On Session    api_auth_invalid_token    ${CATEGORIES_ENDPOINT}    expected_status=401
    Should Contain    ${response.json()}[detail]    Given token not valid for any token type
   

Unauthorized Request Without Headers
    [Documentation]    Verifies that protected endpoint returns 401 with empty headers
    [Tags]    api    auth    security    unauthorized    
    Create Session    api_no_auth    ${BASE_URL}    headers={}
    GET On Session    api_no_auth    ${CATEGORIES_ENDPOINT}    expected_status=401

Unauthorized Request With Refresh Token In Authorization Header
    [Documentation]    Verifies that protected endpoint returns 401 when using a refresh token instead of an access token.
    [Tags]    api    auth    security    unauthorized    wrong_refresh    huti
    ${_}    ${refresh_token}=    Login And Get Tokens
    Create Session    api_wrong_token    ${BASE_URL}    headers={"Authorization":"Bearer ${refresh_token}"}
    GET On Session    api_wrong_token    ${CATEGORIES_ENDPOINT}    expected_status=401


Login With Wrong Credentials
    [Documentation]    Attempts login with completely invalid credentials and expects a 401 error response.
    [Tags]    api    auth    error
    Run Keyword And Expect Error    *401*    Login With Credentials    wrongusername    wrongpassword

Login With Wrong Username
    [Documentation]    Tests login with an incorrect username while using a valid password and expects an error response.
    [Tags]    api    auth    error
    Run Keyword And Expect Error    *Client Error*    Login With Credentials    wrongusername    ${PASSWORD}

Login With Wrong Password
    [Documentation]    Tests login with an incorrect password while using a valid username and expects an error response.
    [Tags]    api    auth    error
    Run Keyword And Expect Error    *Client Error*    Login With Credentials    ${USERNAME}    wrongpassword


Login With Empty Credentials
    [Documentation]    Attempts login with both username and password empty and verifies the API rejects the request.
    [Tags]    api    auth    error
    Run Keyword And Expect Error    *Client Error*    Login With Credentials    ${EMPTY}    ${EMPTY}

Login With Empty Username
    [Documentation]    Attempts login with an empty username and valid password and expects an error response.
    [Tags]    api    auth    error
    Run Keyword And Expect Error    *Client Error*    Login With Credentials    ${EMPTY}    ${PASSWORD}

Login With Empty Password
    [Documentation]    Attempts login with a valid username but empty password and expects an error response.
    [Tags]    api    auth    error
    Run Keyword And Expect Error    *Client Error*    Login With Credentials    ${USERNAME}    ${EMPTY}

Login Without Body Should Fail
    [Documentation]    Attempts login without body
    [Tags]    api    auth    error    no_body
    Run Keyword And Expect Error    *Client Error*    Login Without Body

Login With Invalid Content-Type
    [Documentation]    Ensures API error handling for unsupported request media types.
    [Tags]    api    auth    error    wrong_content_type
    ${response}=    Login With Wrong Content-Type    ${USERNAME}    ${PASSWORD}    text/plain
    Should Be Equal As Integers    ${response.status_code}    415
    Should Contain    ${response.json()}[detail]    Unsupported media type
