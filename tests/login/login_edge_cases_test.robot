*** Settings ***
Library        RequestsLibrary
Library        Collections
Resource       ../resources/auth_keywords.resource   

*** Variables ***

${USERNAME}         %{API_USERNAME}
${PASSWORD}         %{API_PASSWORD}


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
