*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}    chrome

*** Keywords ***
Open My Browser
    [Arguments]    ${BROWSER}
    Open Browser    http://localhost:5173/    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains    EasyList    10s

Close My Browser
    Close Browser




