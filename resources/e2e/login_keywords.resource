*** Settings ***
Library    Browser

*** Keywords ***

Click Login Link
    Click    id=login-link

Click Logout Link
    Click    id=logout-link

Input Username And Password
    [Documentation]    Username and Password
    [Arguments]    ${username}    ${password}
    Wait For Elements State    id=username    visible    7s
    Fill Text    id=username    ${username}
    Fill Text    id=password    ${password}

Submit Login
    Click    id=login-button

Login Should Succeed
    Wait For Elements State    text=Tuotteet    visible    7s
    Get Text    text=Tuotteet

Logout Should Succeed
    Wait For Elements State    id=login-link    visible    10s

Login Should Fail
    Wait For Elements State    text=Virheelliset tunnukset    visible    7s
    Get Text    text=Virheelliset tunnukset

Login Should Fail With Empty Credentials
    Get Property    id=username    required    ==    ${True}
    Wait For Elements State    text=Tuotteet    hidden    2s



Debug Snapshot
    ${url}=    Get Url
    Log    URL: ${url}
    Take Screenshot
