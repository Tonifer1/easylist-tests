*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}    %{API_BASE_URL}
${USERNAME}    %{API_USERNAME}
${PASSWORD}    %{API_PASSWORD}
${LOGIN_ENDPOINT}    /api/token/
${REFRESH_ENDPOINT}    /api/token/refresh/

*** Keywords ***
Login With Credentials
    [Arguments]    ${username}    ${password}
    Create Session    auth    ${BASE_URL}
    &{payload}=    Create Dictionary    username=${username}    password=${password}
    POST On Session    auth    ${LOGIN_ENDPOINT}    json=${payload}

Login And Get Tokens
    [Documentation]    Logs into the API and returns both access and refresh tokens.
    Create Session    auth    ${BASE_URL}
    ${payload}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    POST On Session    auth    ${LOGIN_ENDPOINT}    json=${payload}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=    SetVariable     ${response.json()}
    ${access_token}=    Get From Dictionary    ${json}    access
    ${refresh_token}=    Get From Dictionary    ${json}    refresh
    Log    ${refresh_token}
    RETURN    ${access_token}    ${refresh_token}    

Login And Get Refresh Token
    [Documentation]    Logs into the API and returns an refresh token
    [Arguments]    ${acces_token}    ${refresh_token}    
    Create Session    auth_refresh    ${BASE_URL}
    ${payload}=    Create Dictionary    refresh=${refresh_token}    
    ${response}=    POST On Session    auth_refresh    ${REFRESH_ENDPOINT}    json=${payload}
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${refresh_token}
    ${json}=    SetVariable     ${response.json()}
    ${new_access_token}=    Get From Dictionary    ${json}    access
    RETURN    ${new_access_token}

Login Without Body
    Create Session    auth_no_body    ${BASE_URL}           
    POST On Session    auth_no_body    ${LOGIN_ENDPOINT}

Login With Wrong Content-Type
    [Arguments]    ${username}    ${password}    ${content_type}
    &{payload}=    Create Dictionary    username=${username}    password=${password}     
    Create Session    auth_wrong_content    ${BASE_URL}    headers={"Content-Type":"${content_type}"}
    ${response}=    POST On Session    auth_wrong_content    ${LOGIN_ENDPOINT}    data=${payload}    expected_status=any    
    RETURN    ${response}

Create Authenticated Session
    [Documentation]    Creates an authenticated session with a token.
    ${access_token}    ${refresh_token}=    Login And Get Tokens
    Create Session    api_auth    ${BASE_URL}    headers={"Authorization":"Bearer ${access_token}","Content-Type":"application/json"}