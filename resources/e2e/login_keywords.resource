*** Settings ***
Library    Browser

*** Keywords ***

Click Login Link
    Click    id=login-link

Click Logout Link
    Click    id=logout-link

Input Username And Password
    [Documentation]    Fills the username and password fields with provided values.
    [Arguments]    ${username}    ${password}
    Wait For Elements State    id=username    visible    7s
    Fill Text    id=username    ${username}
    Fill Text    id=password    ${password}

Submit Login
    Click    id=login-button


Logout Link Should Be Visible
    Wait For Elements State    id=logout-link    visible    7s


Login Link Should Be Visible
    Wait For Elements State    id=login-link    visible    7s

Login Error Message Should Be Visible
    Wait For Elements State    text=Virheelliset tunnukset    visible    7s


Username Field Should Be Required
    Get Property    id=username    required    ==    ${True}

Go Back In Browser
    Go Back


Debug Snapshot
    ${url}=    Get Url
    Log    URL: ${url}
    Take Screenshot