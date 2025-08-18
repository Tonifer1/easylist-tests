*** Settings ***
Library        RequestsLibrary
Library        Collections
Resource       login_keyword_test.robot    # tuodaan Login And Get Token

*** Variables ***

${USERNAME}         %{API_USERNAME}
${PASSWORD}         %{API_PASSWORD}


*** Keywords ***
Login With Credentials
    [Arguments]    ${username}    ${password}
    Create Session    auth    ${BASE_URL}
    &{data}=    Create Dictionary    username=${username}    password=${password}
    POST On Session    auth    ${LOGIN_ENDPOINT}    json=${data}

*** Test Cases ***
Login Succeeds And Returns Tokens
    ${token}=    Login And Get Token
    Should Not Be Empty    ${token}
    Should Contain    ${token}    .
    Log    ${token}

Login With Wrong Credentials
    Run Keyword And Expect Error    *401*    Login With Credentials    wrongusername    wrongpassword


Login With Empty Credentials
    Run Keyword And Expect Error    *Client Error*    Login With Credentials    ${EMPTY}    ${EMPTY}
