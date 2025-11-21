*** Settings ***
Documentation    API tests for user authentication and token handling
Library        RequestsLibrary
Library        Collections
Resource       ../resources/api/auth_keywords.resource   

*** Variables ***

${USERNAME}         %{API_USERNAME}
${PASSWORD}         %{API_PASSWORD}


*** Test Cases ***
Login Succeeds And Returns Tokens
    [Tags]    api    auth    smoke
    ${token}=    Login And Get Token
    Should Not Be Empty    ${token}
    Should Contain    ${token}    .
    Log    ${token}

Login With Wrong Credentials
    [Tags]    api    auth    error
    Run Keyword And Expect Error    *401*    Login With Credentials    wrongusername    wrongpassword


Login With Empty Credentials
    [Tags]    api    auth    error
    Run Keyword And Expect Error    *Client Error*    Login With Credentials    ${EMPTY}    ${EMPTY}
