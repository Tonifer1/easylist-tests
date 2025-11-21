*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}    chrome
#robot --variable BROWSER:chrome tests/e2e/main_test.robot


*** Keywords ***
Open My Browser
    [Arguments]    ${BROWSER}
    Open Browser    http://localhost:4173/    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains    EasyList    10s

Close My Browser
    Close Browser




