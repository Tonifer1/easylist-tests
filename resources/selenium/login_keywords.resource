*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}    chrome



*** Keywords ***
Click Login Link
    Click Element    id=login-link

Click Logout Link
    Click Element    id=logout-link

Input Username And Password
    [Documentation]    Username and Passoword
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    id=username     7s
    Input Text    id=username    ${username}
    Input Text    id=password    ${password}

Submit Login
    Click Button    id=login-button

Login Should Succeed
    Wait Until Page Contains    Products    7s
    Page Should Contain    Products

Logout Should Succeed
    Wait Until Page Contains Element    id=login-link
    Page Should Contain Element    id=login-link


Login Should Fail
    Wait Until Page Contains    Virheelliset tunnukset    7s
    Page Should Contain    Virheelliset tunnukset

Login Should Fail With Empty Credentials
    ${required}=    Get Element Attribute    id=username    required
    Should Be Equal    ${required}    true 
    Page Should Not Contain    Products



    