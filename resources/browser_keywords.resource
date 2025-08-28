*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Google
    [Arguments]    ${BROWSER}
    Open Browser    https://www.google.com    ${BROWSER}
    Sleep    5

Close My Browser
    Close Browser




