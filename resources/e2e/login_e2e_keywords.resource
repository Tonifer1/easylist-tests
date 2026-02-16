*** Settings ***
Library    Browser

*** Keywords ***

Click Login Link
    Click    data-testid=nav-login

Click Logout Link
    Click    data-testid=nav-logout

Input Username And Password
    [Documentation]    Fills the username and password fields with provided values.
    [Arguments]    ${username}    ${password}
    Wait For Elements State    data-testid=login-username    visible    7s
    Fill Text    data-testid=login-username    ${username}
    Fill Text    data-testid=login-password    ${password}

Submit Login
    Click    data-testid=login-submit


Logout Link Should Be Visible
    Wait For Elements State    data-testid=nav-logout     visible    7s
   


Login Link Should Be Visible
    Wait For Elements State    data-testid=nav-login    visible    7s

Login Error Message Should Be Visible
    Wait For Elements State    data-testid=login-error    visible    7s


Username Field Should Be Required
    Get Property    data-testid=login-username    required    ==    ${True}

Go Back In Browser
    Go Back


Debug Snapshot
    ${url}=    Get Url
    Log    URL: ${url}
    Take Screenshot