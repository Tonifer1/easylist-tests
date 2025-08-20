*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}    %{API_BASE_URL}
${LOGIN_ENDPOINT}    /api/token/
${USERNAME}    %{API_USERNAME}
${PASSWORD}    %{API_PASSWORD}

*** Keywords ***
Login And Get Token
    [Documentation]    Logs into the API and returns an access token
    Create Session    auth    ${BASE_URL}
    ${data}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    POST On Session    auth    ${LOGIN_ENDPOINT}    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=    SetVariable     ${response.json()}
    ${ACCESTOKEN}=    Get From Dictionary    ${json}    access
    RETURN    ${ACCESTOKEN} 
