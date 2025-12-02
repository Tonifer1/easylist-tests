*** Settings ***
Resource    ../../resources/e2e/open_browser_keywords.resource
Resource    ../../resources/e2e/login_keywords.resource
Test Setup    Open My Browser    ${BROWSER}
Test Teardown    Close My Browser

*** Variables ***
${VALID_USERNAME}    %{API_USERNAME}
${VALID_PASSWORD}    %{API_PASSWORD}
${INVALID_USERNAME}    wronguser
${INVALID_PASSWORD}    wrongpass
${SPECIAL_CHARS}    ¤#%&/()

*** Test Cases ***
Login With Valid Credentials Should Succeed
    [Tags]    e2e    selenium    login
    Click Login Link
    Wait Until Element Is Visible    id=username    7s
    Input Username And Password    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Log To Console    ${VALID_USERNAME}    ${VALID_PASSWORD}    
    Submit Login
    Login Should Succeed
    Click Logout Link
    Logout Should Succeed

Login With Invalid Username Should Fail
    [Tags]    e2e    selenium    login    error
    Click Login Link
    Wait Until Element Is Visible    id=username    7s
    Input Username And Password    ${INVALID_USERNAME}    ${VALID_PASSWORD}
    Submit Login
    Login Should Fail

Login With Invalid Password Should Fail
    [Tags]    e2e    selenium    login    error
    Click Login Link
    Wait Until Element Is Visible    id=username    7s
    Input Username And Password    ${VALID_USERNAME}    ${INVALID_PASSWORD}
    Submit Login
    Login Should Fail

 Login With Special Characters Should Fail
    [Tags]    e2e    selenium    login    error
    Click Login Link
    Wait Until Element Is Visible    id=username    7s
    Input Username And Password    ${SPECIAL_CHARS}    ${SPECIAL_CHARS}
    Submit Login
    Login Should Fail

 Login With Empty Credentials
    [Tags]    e2e    selenium    login    error
    Click Login Link
    Wait Until Element Is Visible    id=username    7s
    Input Username And Password    ${EMPTY}    ${EMPTY}
    Submit Login
    Login Should Fail With Empty Credentials