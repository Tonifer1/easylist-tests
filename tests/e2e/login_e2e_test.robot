*** Settings ***
Resource    ../../resources/e2e/open_browser_e2e_keywords.resource
Resource    ../../resources/e2e/login_e2e_keywords.resource
Test Setup    Open My Browser    
Test Teardown    Close My Browser

*** Variables ***
${VALID_USERNAME}    %{API_USERNAME}
${VALID_PASSWORD}    %{API_PASSWORD}
${INVALID_USERNAME}    wronguser
${INVALID_PASSWORD}    wrongpass
${SPECIAL_CHARS}    ¤#%&/()

*** Test Cases ***
Login With Valid Credentials Should Succeed
    [Tags]    smoke    e2e    browser    login
    [Documentation]    Verifies that a user can log in with valid credentials.
    Click Login Link
    Input Username And Password    ${VALID_USERNAME}    ${VALID_PASSWORD}  
    Submit Login
    Logout Link Should Be Visible
    Click Logout Link
    Login Link Should Be Visible

Login With Invalid Username Should Fail
    [Tags]    smoke    e2e    browser    login    error
    [Documentation]    Verifies that an incorrect username prevents authentication and displays the appropriate error message.
    Click Login Link
    Input Username And Password    ${INVALID_USERNAME}    ${VALID_PASSWORD}
    Submit Login
    Login Error Message Should Be Visible
    Login Link Should Be Visible
    

Login With Invalid Password Should Fail
    [Tags]    smoke    e2e    browser    login    error
    [Documentation]    Verifies that an incorrect password prevents authentication and displays the appropriate error message.
    Click Login Link
    Input Username And Password    ${VALID_USERNAME}    ${INVALID_PASSWORD}
    Submit Login
    Login Error Message Should Be Visible
    Login Link Should Be Visible
    

Login With Special Characters Should Fail
    [Tags]    e2e    browser    login    error
    [Documentation]    Ensures the login form handles special characters correctly by rejecting them and maintaining the logged-out state.
    Click Login Link
    Input Username And Password    ${SPECIAL_CHARS}    ${SPECIAL_CHARS}
    Submit Login
    Login Error Message Should Be Visible
    Login Link Should Be Visible

Login With Empty Credentials
    [Documentation]    Verifies that the login form enforces required fields when the user attempts to submit empty credentials.
    [Tags]    e2e    browser    login    error
    Click Login Link
    Input Username And Password    ${EMPTY}    ${EMPTY}
    Submit Login
    Username Field Should Be Required
    Login Link Should Be Visible

User Should Not Be Logged In After Logout And Browser Back
    [Documentation]    Security test to ensure that navigating back in the browser after logging out does not restore the authenticated session.
    [Tags]    smoke    e2e    browser    security    logout
    Click Login Link
    Input Username And Password    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Submit Login
    Logout Link Should Be Visible
    Click Logout Link
    Login Link Should Be Visible   
    Go Back In Browser
    Login Link Should Be Visible